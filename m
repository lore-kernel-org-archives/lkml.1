Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZCSTj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZCSTj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbZCSTjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:39:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34263 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbZCSTjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:39:18 -0400
Date: Thu, 19 Mar 2009 19:39:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Christopher Li <sparse@chrisli.org>, linux-sparse@vger.kernel.org,
       Hannes Eder <hannes@hanneseder.net>, linux-kernel@vger.kernel.org
Subject: Re: Nasal demons in preprocessor use (Re: [PATCH] test-suite: new
	preprocessor test case)
Message-ID: <20090319193910.GE28946@ZenIV.linux.org.uk>
References: <20090319175544.13691.42362.stgit@f10box.hanneseder.net> <20090319182628.GB28946@ZenIV.linux.org.uk> <154e089b0903191151q37ab7b20o43838845af12966f@mail.gmail.com> <20090319190730.GC28946@ZenIV.linux.org.uk> <20090319192758.GB24318@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319192758.GB24318@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 08:27:58PM +0100, Ingo Molnar wrote:
> Vegard, it's this bit:
> 
>         kmemcheck_define_bitfield(flags2, {
> #ifdef CONFIG_IPV6_NDISC_NODETYPE
>                 __u8                    ndisc_nodetype:2;
> #endif
> #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
>                 __u8                    do_not_encrypt:1;
>                 __u8                    requeue:1;
> #endif
>         });

BTW, there's a related turd: kernel/cred.c
        if (
#ifdef CONFIG_KEYS
                !p->cred->thread_keyring &&
#endif
                clone_flags & CLONE_THREAD
            ) {
is not only ucking fugly, it's not a valid C if you have PROFILE_ALL_BRANCHES
set.  Why?  Because then we get if() #defined ;-/

BTW^2, speaking of that ifdef...  What happens to
static void put_cred_rcu(struct rcu_head *rcu)
{
        struct cred *cred = container_of(rcu, struct cred, rcu);

        if (atomic_read(&cred->usage) != 0)
                panic("CRED: put_cred_rcu() sees %p with usage %d\n",
                      cred, atomic_read(&cred->usage));

        security_cred_free(cred);
        key_put(cred->thread_keyring);
        key_put(cred->request_key_auth);
        release_tgcred(cred);
        put_group_info(cred->group_info);
        free_uid(cred->user);
        kmem_cache_free(cred_jar, cred);
}
if CONFIG_KEYS is not set?
