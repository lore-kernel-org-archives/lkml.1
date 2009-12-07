Return-Path: <linux-kernel-owner+w=401wt.eu-S934560AbZLGAbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbZLGAbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758398AbZLGAM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:56 -0500
Received: from kroah.org ([198.145.64.141]:34287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371AbZLGAMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:49 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:45 2009
Message-Id: <20091207000645.124173920@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [030/119] uids: Prevent tear down race
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=uids-prevent-tear-down-race.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit b00bc0b237055b4c45816325ee14f0bd83e6f590 upstream.

Ingo triggered the following warning:

WARNING: at lib/debugobjects.c:255 debug_print_object+0x42/0x50()
Hardware name: System Product Name
ODEBUG: init active object type: timer_list
Modules linked in:
Pid: 2619, comm: dmesg Tainted: G        W  2.6.32-rc5-tip+ #5298
Call Trace:
 [<81035443>] warn_slowpath_common+0x6a/0x81
 [<8120e483>] ? debug_print_object+0x42/0x50
 [<81035498>] warn_slowpath_fmt+0x29/0x2c
 [<8120e483>] debug_print_object+0x42/0x50
 [<8120ec2a>] __debug_object_init+0x279/0x2d7
 [<8120ecb3>] debug_object_init+0x13/0x18
 [<810409d2>] init_timer_key+0x17/0x6f
 [<81041526>] free_uid+0x50/0x6c
 [<8104ed2d>] put_cred_rcu+0x61/0x72
 [<81067fac>] rcu_do_batch+0x70/0x121

debugobjects warns about an enqueued timer being initialized. If
CONFIG_USER_SCHED=y the user management code uses delayed work to
remove the user from the hash table and tear down the sysfs objects.

free_uid is called from RCU and initializes/schedules delayed work if
the usage count of the user_struct is 0. The init/schedule happens
outside of the uidhash_lock protected region which allows a concurrent
caller of find_user() to reference the about to be destroyed
user_struct w/o preventing the work from being scheduled. If the next
free_uid call happens before the work timer expired then the active
timer is initialized and the work scheduled again.

The race was introduced in commit 5cb350ba (sched: group scheduling,
sysfs tunables) and made more prominent by commit 3959214f (sched:
delayed cleanup of user_struct)

Move the init/schedule_delayed_work inside of the uidhash_lock
protected region to prevent the race.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Paul E. McKenney <paulmck@us.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/user.c
+++ b/kernel/user.c
@@ -330,9 +330,9 @@ done:
  */
 static void free_user(struct user_struct *up, unsigned long flags)
 {
-	spin_unlock_irqrestore(&uidhash_lock, flags);
 	INIT_DELAYED_WORK(&up->work, cleanup_user_struct);
 	schedule_delayed_work(&up->work, msecs_to_jiffies(1000));
+	spin_unlock_irqrestore(&uidhash_lock, flags);
 }
 
 #else	/* CONFIG_USER_SCHED && CONFIG_SYSFS */


