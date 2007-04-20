Return-Path: <linux-kernel-owner+w=401wt.eu-S2992617AbXDTMhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992617AbXDTMhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992675AbXDTMhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:37:47 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:16085 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992617AbXDTMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:37:46 -0400
Message-ID: <4628B414.6000906@fr.ibm.com>
Date: Fri, 20 Apr 2007 14:37:40 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: devel@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph@smtp2.linux-foundation.org, Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org, Hellwig <hch@infradead.org>,
       containers@lists.osdl.org, Marcel@smtp2.linux-foundation.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [Devel] Re: [PATCH] bluetooth bnep: Convert to kthread API.
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <1176969596686-git-send-email-ebiederm@xmission.com> <20070419162459.af7a182c.akpm@linux-foundation.org> <462893F4.1000005@fr.ibm.com>
In-Reply-To: <462893F4.1000005@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
> Andrew Morton wrote:
>> On Thu, 19 Apr 2007 01:58:51 -0600
>> "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>>
>>> From: Eric W. Biederman <ebiederm@xmission.com>
>>>
>>> This patch starts kbenpd using kthread_run replacing
>>> a combination of kernel_thread and daemonize.  Making
>>> the code a little simpler and more maintainable.
>>>
>>>
>> 	while (!atomic_read(&s->killed)) {
>>
>> ho hum.
> 
> 
> yes. we need something like :
> 
> -       while (!atomic_read(&s->killed)) {
> +       while (1) {
>                 try_to_freeze();
>  
>                 set_current_state(TASK_INTERRUPTIBLE);
>  
> +               if (atomic_read(&s->killed))
> +                       break;
> +
> 
> I have an old patch for this driver. I'll refresh it.
> 
>>> +	task = kthread_run(bnep_session, s, "kbnepd %s", dev->name);
>> It's unusual to have a kernel thread which has a space in its name.  That
>> could trip up infufficient-defensive userspace tools.
> 
> but we can't just change it, can we ? i could be used by a user space tool 
> to check if the thread is running.

here's the refreshed version not taking into account the space in its 
kernel thread name. 

C.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>

---
 net/bluetooth/bnep/core.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: 2.6.21-rc6-mm1/net/bluetooth/bnep/core.c
===================================================================
--- 2.6.21-rc6-mm1.orig/net/bluetooth/bnep/core.c
+++ 2.6.21-rc6-mm1/net/bluetooth/bnep/core.c
@@ -47,6 +47,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
+#include <linux/kthread.h>
 
 #include <asm/unaligned.h>
 
@@ -473,16 +474,18 @@ static int bnep_session(void *arg)
 
 	BT_DBG("");
 
-	daemonize("kbnepd %s", dev->name);
 	set_user_nice(current, -15);
 
 	init_waitqueue_entry(&wait, current);
 	add_wait_queue(sk->sk_sleep, &wait);
-	while (!atomic_read(&s->killed)) {
+	while (1) {
 		try_to_freeze();
 
 		set_current_state(TASK_INTERRUPTIBLE);
 
+		if (atomic_read(&s->killed))
+			break;
+
 		// RX
 		while ((skb = skb_dequeue(&sk->sk_receive_queue))) {
 			skb_orphan(skb);
@@ -539,6 +542,7 @@ static struct device *bnep_get_device(st
 
 int bnep_add_connection(struct bnep_connadd_req *req, struct socket *sock)
 {
+	struct task_struct *task;
 	struct net_device *dev;
 	struct bnep_session *s, *ss;
 	u8 dst[ETH_ALEN], src[ETH_ALEN];
@@ -598,9 +602,10 @@ int bnep_add_connection(struct bnep_conn
 
 	__bnep_link_session(s);
 
-	err = kernel_thread(bnep_session, s, CLONE_KERNEL);
-	if (err < 0) {
-		/* Session thread start failed, gotta cleanup. */
+	task = kthread_run(bnep_session, s, "kbnepd %s", dev->name);
+	if (IS_ERR(task)) {
+ 		/* Session thread start failed, gotta cleanup. */
+		err = PTR_ERR(task);
 		unregister_netdev(dev);
 		__bnep_unlink_session(s);
 		goto failed;
