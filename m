Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYBCF2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYBCF2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 00:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbYBCF2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 00:28:43 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:11762 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYBCF2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 00:28:42 -0500
Message-ID: <f73f7ab80802022128k2226b2f7r3c69ea1595073619@mail.gmail.com>
Date: Sun, 3 Feb 2008 00:28:41 -0500
From: "Kyle Moffett" <kyle@moffetthome.net>
To: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [NET/IPv6] Race condition with flow_cache_genid?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I was poking around trying to figure out how to install the Mobile
IPv6 daemons this evening and noticed they required a kernel patch,
although upon further inspection the kernel patch seemed to already be
applied in 2.6.24.  Unfortunately the flow cache appears to be
horribly racy.  Attached below are the only uses of the variable
"flow_cache_genid" in 2.6.24.

Now, I am no expert in this particular area of the code, but the
"atomic_t flow_cache_genid" variable is ONLY ever used with
atomic_inc() and atomic_read().  There are no memory barriers or other
dec_and_test()-style functions, so that variable could just as easily
be replaced with a plain old C int.

Basically either there is some missing locking here or it does not
need to be "atomic_t".  Judging from the way it *appears* to be used
to check if cache entries are up-to-date with the latest changes in
policy, I would guess the former.

In particular that whole "flow_cache_lookup()" thing looks racy as
hell, since somebody could be in the middle of that looking at "if
(fle->genid == atomic_read(&flow_cache_genid))".  It does the
atomic_read(), which BTW is literally implemented as:
  #define atomic_read(atomicvar) ((atomicvar)->value)
on some platforms.  Immediately after the atomic read (or even before,
since there's no cache-flush or read-modify-write), somebody calls
into "selinux_xfrm_notify_policyload()" and increments the
flow_cache_genid becase selinux just loaded a security policy.  Now
we're accepting a cache entry which applies to PREVIOUS security
policy.  I can only assume that's really bad.

Even worse, there seems to be a race between SELinux loading a new
policy and calling selinux_xfrm_notify_policyload(), since we could
easily get packets and process them according to the old cache entry
on one CPU before SELinux has had a chance to update the generation ID
from the other.  Furthermore, there's no guarantee the CPU caches will
get updated in reasonable time.  Clearly SELinux needs to have some
way of atomically invalidating the flow cache of all CPUs
*simultaneously* with loading a new policy, which probably means they
both need to be under the same lock, or something.

The same problem appears to occur with updating the XFRM policy and
incrementing flow_cache_genid.  Probably the fastest solution is to
put the flow cache under the xfrm_policy_lock (which already disables
local bottom-halves), and either take that lock during SELinux policy
load or if there are lock ordering problems then add a variable
"flow_cache_ignore" and change the xfrm_notify hooks:

void selinux_xfrm_notify_policyload_pre(void)
{
	write_lock_bh(&xfrm_policy_lock);
	flow_cache_genid++;
	flow_cache_ignore = 1;
	write_unlock_bh(&xfrm_policy_lock);
}

void selinux_xfrm_notify_policyload_post(void)
{
	write_lock_bh(&xfrm_policy_lock);
	flow_cache_ignore = 0;
	write_unlock_bh(&xfrm_policy_lock);
}

Cheers,
Kyle Moffett


BEGIN QUOTED CODE INVOLVING flow_cache_genid:

include/net/flow.h:94:
extern atomic_t flow_cache_genid;

net/core/flow.c:39:
atomic_t flow_cache_genid = ATOMIC_INIT(0);

net/core/flow.c:169:flow_cache_lookup():
	if (flow_hash_rnd_recalc(cpu))
		flow_new_hash_rnd(cpu);
	hash = flow_hash_code(key, cpu);

	head = &flow_table(cpu)[hash];
	for (fle = *head; fle; fle = fle->next) {
		if (fle->family == family &&
				fle->dir == dir &&
				flow_key_compare(key, &fle->key) == 0) {
			if (fle->genid == atomic_read(&flow_cache_genid)) {
				void *ret = fle->object;

				if (ret)
					atomic_inc(fle->object_ref);
				local_bh_enable();

				return ret;
			}
			break;
		}
	}

net/xfrm/xfrm_policy.c:1025:
int xfrm_policy_delete(struct xfrm_policy *pol, int dir)
{
	write_lock_bh(&xfrm_policy_lock);
	pol = __xfrm_policy_unlink(pol, dir);
	write_unlock_bh(&xfrm_policy_lock);
	if (pol) {
		if (dir < XFRM_POLICY_MAX)
			atomic_inc(&flow_cache_genid);
		xfrm_policy_kill(pol);
		return 0;
	}
	return -ENOENT;
}

net/ipv6/inet6_connection_sock.c:142:
static inline
void __inet6_csk_dst_store(struct sock *sk, struct dst_entry *dst,
		struct in6_addr *daddr, struct in6_addr *saddr)
{
	__ip6_dst_store(sk, dst, daddr, saddr);

#ifdef CONFIG_XFRM
	{
		struct rt6_info *rt = (struct rt6_info  *)dst;
		rt->rt6i_flow_cache_genid = atomic_read(&flow_cache_genid);
	}
#endif
}

security/selinux/include/xfrm.h:41:
static inline void selinux_xfrm_notify_policyload(void)
{
        atomic_inc(&flow_cache_genid);
}
