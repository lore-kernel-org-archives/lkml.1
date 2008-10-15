Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbYJOOu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbYJOOu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYJOOuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:50:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:3150 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYJOOut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wZb2sYeX5/RJLbRewqfsgrBdqnvKm1CZrpWsZsuj/gg4XdMwT8he/kY++7zHychJ+5
         CycmMrXwcK018IivXee6WyTHoMLY7HstXYPJd/hjVbqQm0VifYwFOPRyBXwHSi82Wolz
         EXM3mx1IYDe8H0UsTqjXuUssMXcwueWXpQNig=
Message-ID: <804dabb00810150750sb54377dhc83841dedee0f72b@mail.gmail.com>
Date: Wed, 15 Oct 2008 22:50:45 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Problem with set_current_state() and schedule()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am puzzled over this:

The module just consist of three function:

static int myfunction(void)
{
       dbg("%s - enter....", __FUNCTION__);

       while (!kthread_should_stop()) {
               dbg("%s - executing....", __FUNCTION__);
               set_current_state(TASK_INTERRUPTIBLE);
               printk("sssssssssssssssssssssssssssssssss\n");


               schedule(); ======>       ////// removed for part 2
               printk("sssssssssssssssssssssssssssssssss\n");======>//////
removed for part 2


               msleep(1000);
               schedule();
       }
       return 0;
       dbg("%s exit", __FUNCTION__);
}

int init_module(void)
{

       g_task = kthread_run(myfunction, NULL, "mykthread");

       return 0;
}

void cleanup_module(void)
{
       printk(KERN_INFO "Goodbye mykthread.\n");
       kthread_stop(g_task);
}

Below is the dmesg out .... noticed two parts (based on timing output):

Part 1:
[ 1160.348000] mykthread: myfunction - enter....
[ 1160.348000] mykthread: myfunction - executing....
[ 1160.348000] sssssssssssssssssssssssssssssssss
[ 1208.632000] Goodbye mykthread.=======> this is because I "rmmod",
otherwise it got stuck in the previous statement.

Part 2:
[ 1208.632000] sssssssssssssssssssssssssssssssss
[ 1225.612000] mykthread: myfunction - enter....
[ 1225.612000] mykthread: myfunction - executing....
[ 1225.612000] sssssssssssssssssssssssssssssssss
[ 1226.616000] mykthread: myfunction - executing....
[ 1226.616000] sssssssssssssssssssssssssssssssss
[ 1227.620000] mykthread: myfunction - executing....
[ 1227.620000] sssssssssssssssssssssssssssssssss
[ 1228.624000] mykthread: myfunction - executing....
[ 1228.624000] sssssssssssssssssssssssssssssssss
[ 1229.628000] mykthread: myfunction - executing....
[ 1229.628000] sssssssssssssssssssssssssssssssss
[ 1230.632000] mykthread: myfunction - executing....
[ 1230.632000] sssssssssssssssssssssssssssssssss
[ 1231.636000] mykthread: myfunction - executing....
[ 1231.636000] sssssssssssssssssssssssssssssssss
[ 1232.640000] mykthread: myfunction - executing....
[ 1232.640000] sssssssssssssssssssssssssssssssss
[ 1233.644000] mykthread: myfunction - executing....
[ 1233.644000] sssssssssssssssssssssssssssssssss
[ 1234.648000] mykthread: myfunction - executing....
[ 1234.648000] sssssssssssssssssssssssssssssssss
[ 1235.652000] mykthread: myfunction - executing....
[ 1235.652000] sssssssssssssssssssssssssssssssss
[ 1236.656000] mykthread: myfunction - executing....
[ 1236.656000] sssssssssssssssssssssssssssssssss
[ 1237.660000] mykthread: myfunction - executing....
[ 1237.660000] sssssssssssssssssssssssssssssssss
[ 1238.664000] mykthread: myfunction - executing....
[ 1238.664000] sssssssssssssssssssssssssssssssss
[ 1239.668000] mykthread: myfunction - executing....
[ 1239.668000] sssssssssssssssssssssssssssssssss
[ 1240.672000] mykthread: myfunction - executing....
[ 1240.672000] sssssssssssssssssssssssssssssssss
[ 1241.676000] mykthread: myfunction - executing....
[ 1241.676000] sssssssssssssssssssssssssssssssss
[ 1242.680000] mykthread: myfunction - executing....
[ 1242.680000] sssssssssssssssssssssssssssssssss

For part 1:

After printing one line, the program never seemed to continue anymore.
  why?   It got stuck in the first schedule().

For part 2:

Just remove the "remove for part 2".   And u can immediately see that
it starts to loop forever.   So effectively there is only one
schedule() in the while loop.

Why?

I am quite puzzled......thanks in advance for the help.   :-).

-- 
Regards,
Peter Teoh
