Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0CDDWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:22:06 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63879 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0CDDWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:22:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=CguDyWEieKl5zNp15E9q1wUIQUqDFBrdV0hYzipSQ0pdZft4EsbRH7e7IP+Oz72U7c
         wnI7ghpCUsOljpP9XCQU/xbqpFRYAzJdmpLpMOgzX1OI+n4o/7s4GMq7u4K26pqYw3Gl
         KIG/zbdPf1JqA9KUffy3VfHjQsQf0GQ9qAKzc=
MIME-Version: 1.0
Date: Thu, 4 Mar 2010 12:21:59 +0900
Message-ID: <ac85e7a01003031921x2102d554q86c76e560f7ef6f4@mail.gmail.com>
Subject: [rt sched] SCHED_FIFO task of lower rt_priority blocks higher one
From: Xianwei Zeng <linux.xianwei.zeng@gmail.com>
To: linux-rt-users@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e64ea1d60ae07d0480f11a53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64ea1d60ae07d0480f11a53
Content-Type: text/plain; charset=ISO-8859-1

Hi,

# sorry, rejected by mail list server, change the format and resend it

I am using the linux-2.6.29.6-rt24 kernel on an ARM11MPCore (SMP, 4
cores) system.

In this kernel, a SCHED_FIFO task which does the following things seems
can block other real-time processes of higher rt priority on the same CPU
core (the test program is also attached):

static void child_yielder(void)
{
        struct sched_param sp;

        memset (&sp, 0, sizeof sp);
        sp.sched_priority = 10;     /* Arbitrary rt priority */

        if (sched_setscheduler (0, SCHED_FIFO, &sp) != 0)
        {
        perror("sched_setscheduler()");
        exit (1);
        }

    while (1) {
        sched_yield();
    }
}

In other words, no other tasks can be scheduled, including the per-cpu's
keventd kernel thread which has the highest rt priority(keventd is
SCHED_FIFO, and rt_priority = 1). But real-time tasks with lower
rt_priority can get scheduled. This sounds strange to me.

I checked sched_rt.c of my kernel version(The latest kernel is almost
the same in this part), and try to understand how a real-time task is
enqueued, dequeued and picked up:

  * enqueue a real-time task
    - task->prio is used to find the list in rt_prio_array and add task to it;
    - Set the bit in rt_prio_array->bitmap by task->prio;

  * dequeue a real-time task
    - Remove task from the list in rt_prio_array
    - Clear the bit in rt_prio_array->bitmap by task->prio;

  * pick up next real-time task
    - Call sched_find_first_bit(array->bitmap) to find the list
    - Pick the task in the list head

  * yield a real-time task
    - Instead of doing dequeue followed by enqueue, calls
      requeue_task_rt() which moves the task from its current place to
      the list tail.

In all above operations, task->prio is used to find the bit in runqueue
bitmap. Except for Priority Inherient, task->prio is equal to
task->normal_prio which is calculated by function normal_prio(). For
real-time task, its normal_prio is:

   normal_prio = MAX_RT_PRIO - 1 - task->rt_priority;

So the place  of a higher rt_priority real-time task is always
__behind__ the lower rt_priority one in the runqueue bitmap. So that
sched_find_first_bit() picks up the lower rt_priority task to run.

That is why a SCHED_FIFO task can block higher rt_priority SCHED_FIFO
tasks but lower rt_priority real-time task can be scheduled in my test.

But I am confuse about:

  * Does the real-time scheduler work as designed?
  * Or arm I doing the wrong thing in my test?
  * Why not use rt_priority to enqueue and dequeue real-time task
    to/from runqueue list?

Can somebody have a look at my questions? Thanks.

--
Best Regards,
Zeng Xianwei

--0016e64ea1d60ae07d0480f11a53
Content-Type: text/x-csrc; charset=US-ASCII; name="rt-sched.c"
Content-Disposition: attachment; filename="rt-sched.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g6czgd650

I2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3RkbGliLmg+CiNpbmNsdWRlIDxzdGRpby5o
PgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzaWduYWwuaD4KI2luY2x1ZGUgPHNjaGVk
Lmg+CiNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KCiNkZWZpbmUgTlVNX1RBU0tTICAgNQojZGVmaW5l
IFBBUkVOVF9QUklPIDEwICAgLyogUGFyZW50J3MgcnQgcHJpb3JpdHkgKi8KCnN0YXRpYyB2b2lk
IGNoaWxkX3lpZWxkZXIoaW50IHJ0X3ByaW8pOwoKaW50IG1haW4gKGludCBhcmdjLCBjaGFyICoq
YXJndikKewogICAgICAgIHN0cnVjdCBzY2hlZF9wYXJhbSBzcDsKCXBpZF90IGNoaWxkOwoJaW50
IGkgPSAwOwoKICAgICAgICBtZW1zZXQgKCZzcCwgMCwgc2l6ZW9mIHNwKTsKICAgICAgICBzcC5z
Y2hlZF9wcmlvcml0eSA9IFBBUkVOVF9QUklPOwogICAgICAgIGlmIChzY2hlZF9zZXRzY2hlZHVs
ZXIgKDAsIFNDSEVEX0ZJRk8sICZzcCkgIT0gMCkKICAgICAgICB7CgkJcGVycm9yKCJzY2hlZF9z
ZXRzY2hlZHVsZXIoKSIpOwoJCWV4aXQgKDEpOwogICAgICAgIH0KCglmb3IgKGkgPSAxOyBpIDw9
IE5VTV9UQVNLUzsgaSsrKSB7CgkJY2hpbGQgPSBmb3JrKCk7CgkJc3dpdGNoIChjaGlsZCkgewoJ
CWNhc2UgMDogLyogQ2hpbGQgKi8KCQkJLyogQ2hpbGQgaGFzIGxvd2VyIHJ0IHByaW9yaXR5IHRo
YW4gcGFyZW50ICovCgkJCWNoaWxkX3lpZWxkZXIoUEFSRU5UX1BSSU8gKyBpKTsKCQkJYnJlYWs7
CgkJY2FzZSAtMTogLyogRXJyb3IgKi8KCQkJcGVycm9yKCJmb3JrKCkiKTsKCQkJa2lsbCgwLCBT
SUdURVJNKTsKCQkJYnJlYWs7CgkJZGVmYXVsdDogLyogUGFyZW50ICovCgkJCXByaW50ZiAoIlBh
cmVudDogY3JhZXRlIGNoaWxkIHBpZCAlZFxuIiwgY2hpbGQpOwoJCQlicmVhazsKCQl9Cgl9CgoJ
cHJpbnRmKCItLSBQYXJlbnQgRU5EIC0tXG4iKTsKCQoJLyogRXhpdCBhbmQgbGVhdmUgY2hpbGQg
cHJvY2Vzc2VzIHJ1bm5pbmcgKi8KCS8qIGtpbGwoMCwgU0lHVEVSTSk7ICovCglyZXR1cm4gMDsK
fQoKc3RhdGljIHZvaWQgY2hpbGRfeWllbGRlcihpbnQgcnRfcHJpbykKewogICAgICAgIHN0cnVj
dCBzY2hlZF9wYXJhbSBzcDsKCglwcmludGYgKCJDaGlsZCBydW5uaW5nOiBwaWQgPSAlZFxuIiwg
Z2V0cGlkKCkpOwoKICAgICAgICBtZW1zZXQgKCZzcCwgMCwgc2l6ZW9mIHNwKTsKICAgICAgICBz
cC5zY2hlZF9wcmlvcml0eSA9IHJ0X3ByaW87CgogICAgICAgIGlmIChzY2hlZF9zZXRzY2hlZHVs
ZXIgKDAsIFNDSEVEX0ZJRk8sICZzcCkgIT0gMCkKICAgICAgICB7CgkJcGVycm9yKCJzY2hlZF9z
ZXRzY2hlZHVsZXIoKSIpOwoJCWV4aXQgKDEpOwogICAgICAgIH0KCgl3aGlsZSAoMSkgewoJCXNj
aGVkX3lpZWxkKCk7Cgl9Cn0K
--0016e64ea1d60ae07d0480f11a53--
