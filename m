Return-Path: <linux-kernel-owner+w=401wt.eu-S966124AbXDJJGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966124AbXDJJGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 05:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966135AbXDJJGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 05:06:55 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:48146 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966124AbXDJJGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 05:06:54 -0400
Message-ID: <461B53CD.1030603@free.fr>
Date: Tue, 10 Apr 2007 11:07:25 +0200
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@timesys.com,
       John <linux.kernel@free.fr>
Subject: Re: 2.6.20-rt8 patch tweaked for 2.6.20.5
References: <461672D8.7090100@free.fr> <20070406173639.GA2929@elte.hu>
In-Reply-To: <20070406173639.GA2929@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> John wrote:
> 
>> I've tweaked patch-2.6.20-rt8 so that it applies to 2.6.20.5
>>
>> The unified diff is attached to this message.
> 
> thanks - this is useful to those who are not that much on the bleeding
> edge.
> 
>> I'd be happy to hear comments on what I've done wrong.
>>
>> 78 hunks had to be offset and 3 hunks had to be fuzzed.
>>
>> $ grep -B1 fuzz patch.log
>> patching file arch/ia64/kernel/iosapic.c
>> Hunk #3 succeeded at 469 with fuzz 2.
>> --
>> patching file kernel/fork.c
>> Hunk #9 succeeded at 975 with fuzz 1.
>> --
>> patching file kernel/sched.c
>> Hunk #46 succeeded at 3996 with fuzz 1.
>>
>> What is the fuzz value, exactly?
> 
> it's harmless: when the 'patch' utility didn't find the 'context' of the 
> patch chunk at its claimed position (because all patch chunks have 
> precise coordinates of source code embedded), but finds them 'nearby' 
> (or at least, somewhere in the file), it emits this reminder that the 
> underlying code did change since the patch was generated. Generating a 
> 'clean' patch will get rid of these messages.

Ingo,

I'd be happy to generate a clean patch!
(Would you agree to host it in your directory?)
http://people.redhat.com/mingo/realtime-preempt/older/

What options did you run diff with to generate the original patch?

diff -upr ? How do you prevent diff from printing timestamps?

Could you, or Thomas, or someone else, take a look at my patch,
and tell me if everything looks right before I go ahead?


I've documented all the changes below:


1. linux/Makefile (trivial)
Tweak EXTRAVERSION to change .5 into .5-rt8


2. linux/drivers/kvm/kvm.h
Remove a patch that was already applied to 2.6.20.2
cf. patch-2.6.20.2

--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -558,7 +558,7 @@ static inline void load_gs(u16 sel)
  #ifndef load_ldt
  static inline void load_ldt(u16 sel)
  {
-	asm ("lldt %0" : : "g"(sel));
+	asm ("lldt %0" : : "rm"(sel));
  }
  #endif


3. linux/kernel/futex.c
[ I'm not sure I've made the appropriate changes here ]

Basically, we want to replace
   spin_lock(&pi_state->pi_mutex.wait_lock);
with
   spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);

and we want to replace
   spin_unlock(&pi_state->pi_mutex.wait_lock);
with
   spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);

Is that correct?


4. linux/kernel/time/clocksource.c
Provide an #include directive added by patch-2.6.20.2
Remove the first line to keep patch happy.

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -28,6 +28,7 @@
  #include <linux/sysdev.h>
  #include <linux/init.h>
  #include <linux/module.h>
+#include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() 
m68k */

  /* XXX - Would like a better way for initializing curr_clocksource */
  extern struct clocksource clocksource_jiffies;


5. linux/net/xfrm/xfrm_user.c
[ I'm not sure I've made the appropriate changes here ]

Remove a patch that was already applied to 2.6.20.2
cf. patch-2.6.20.2

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1273,10 +1273,6 @@ static int xfrm_get_policy(struct sk_buff *skb, 
struct nlmsghdr *nlh,
  		xp = xfrm_policy_bysel_ctx(type, p->dir, &p->sel, tmp.security, delete);
  		security_xfrm_policy_free(&tmp);
  	}
-	if (delete)
-		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
-			       AUDIT_MAC_IPSEC_DELSPD, (xp) ? 1 : 0, xp, NULL);
-
  	if (xp == NULL)
  		return -ENOENT;

@@ -1292,8 +1288,14 @@ static int xfrm_get_policy(struct sk_buff *skb, 
struct nlmsghdr *nlh,
  					      MSG_DONTWAIT);
  		}
  	} else {
-		if ((err = security_xfrm_policy_delete(xp)) != 0)
+		err = security_xfrm_policy_delete(xp);
+
+		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
+			       AUDIT_MAC_IPSEC_DELSPD, err ? 0 : 1, xp, NULL);
+
+		if (err != 0)
  			goto out;
+
  		c.data.byid = p->index;
  		c.event = nlh->nlmsg_type;
  		c.seq = nlh->nlmsg_seq;


As a side note, I find the expression
   err ? 0 : 1
suspect. Why not write !err ?

Regards.
