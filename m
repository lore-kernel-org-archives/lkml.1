Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbZLWWLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbZLWWLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 17:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZLWWLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 17:11:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50260 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZLWWLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 17:11:52 -0500
Date: Thu, 24 Dec 2009 09:11:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the acpi tree with Linus' tree
Message-Id: <20091224091141.fa1cea64.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Today's linux-next merge of the acpi tree got a conflict in
drivers/platform/x86/sony-laptop.c between commits
45465487897a1c6d508b14b904dc5777f7ec7e04 ("kfifo: move struct kfifo in
place"), c1e13f25674ed564948ecb7dfe5f83e578892896 ("kfifo: move out
spinlock") and 7acd72eb85f1c7a15e8b5eb554994949241737f1 ("kfifo: rename
kfifo_put... into kfifo_in... and kfifo_get... into kfifo_out...") from
Linus' tree and commit a287e9f941cf4bb8c167802c0f1cf04a93bc4e4c
("sony-laptop: remove private workqueue, use keventd instead") from the
acpi tree.

I fixed it up (see below) and can cay the fix for a while.  This fix
needs checking.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/sony-laptop.c
index 2896ca4,51314b4..0000000
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@@ -142,9 -143,8 +143,8 @@@ struct sony_laptop_input_s 
  	atomic_t		users;
  	struct input_dev	*jog_dev;
  	struct input_dev	*key_dev;
 -	struct kfifo		*fifo;
 +	struct kfifo		fifo;
  	spinlock_t		fifo_lock;
- 	struct workqueue_struct	*wq;
  };
  
  static struct sony_laptop_input_s sony_laptop_input = {
@@@ -298,12 -300,12 +300,13 @@@ static int sony_laptop_input_keycode_ma
  /* release buttons after a short delay if pressed */
  static void do_sony_laptop_release_key(struct work_struct *work)
  {
+ 	struct delayed_work *dwork =
+ 			container_of(work, struct delayed_work, work);
  	struct sony_laptop_keypress kp;
  
- 	while (kfifo_out_locked(&sony_laptop_input.fifo, (unsigned char *)&kp,
 -	if (kfifo_get(sony_laptop_input.fifo,
 -		      (unsigned char *)&kp, sizeof(kp)) == sizeof(kp)) {
++	if (kfifo_out_locked(&sony_laptop_input.fifo, (unsigned char *)&kp,
 +			sizeof(kp), &sony_laptop_input.fifo_lock)
 +			== sizeof(kp)) {
- 		msleep(10);
  		input_report_key(kp.dev, kp.key, 0);
  		input_sync(kp.dev);
  	}
@@@ -363,13 -375,12 +376,14 @@@ static void sony_laptop_report_input_ev
  		/* we emit the scancode so we can always remap the key */
  		input_event(kp.dev, EV_MSC, MSC_SCAN, event);
  		input_sync(kp.dev);
+ 
+ 		/* schedule key release */
 -		kfifo_put(sony_laptop_input.fifo,
 -			  (unsigned char *)&kp, sizeof(kp));
 +		kfifo_in_locked(&sony_laptop_input.fifo,
 +			  (unsigned char *)&kp, sizeof(kp),
 +			  &sony_laptop_input.fifo_lock);
 +
- 		if (!work_pending(&sony_laptop_release_key_work))
- 			queue_work(sony_laptop_input.wq,
- 					&sony_laptop_release_key_work);
+ 		schedule_delayed_work(&sony_laptop_release_key_work,
+ 				      msecs_to_jiffies(10));
  	} else
  		dprintk("unknown input event %.2x\n", event);
  }
@@@ -470,11 -474,8 +475,8 @@@ err_unregister_keydev
  err_free_keydev:
  	input_free_device(key_dev);
  
- err_destroy_wq:
- 	destroy_workqueue(sony_laptop_input.wq);
- 
  err_free_kfifo:
 -	kfifo_free(sony_laptop_input.fifo);
 +	kfifo_free(&sony_laptop_input.fifo);
  
  err_dec_users:
  	atomic_dec(&sony_laptop_input.users);
@@@ -499,8 -508,7 +509,7 @@@ static void sony_laptop_remove_input(vo
  		sony_laptop_input.jog_dev = NULL;
  	}
  
- 	destroy_workqueue(sony_laptop_input.wq);
 -	kfifo_free(sony_laptop_input.fifo);
 +	kfifo_free(&sony_laptop_input.fifo);
  }
  
  /*********** Platform Device ***********/
