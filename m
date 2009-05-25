Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZEYQWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZEYQWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 12:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZEYQVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 12:21:54 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:38753 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZEYQVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 12:21:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KsTM930NcGDramdZhwnenv73vV1DJDOvEO+5SINDGAZ7SR6rzCAuHt3wTwFTD24mSa
         djysPocnVIF+Qm2J/k9TdQ4eaJ+B0apAMWs1enYK6RUmMtjgZLFqbRjBvI5wRxmuWVOx
         QzrHwJkX45kglUkp4fZyjVD1pBUHkZlOihFbo=
Message-ID: <4A1AC5A3.9000600@gmail.com>
Date: Mon, 25 May 2009 18:21:55 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b5pre) Gecko/20090511 SUSE/3.0b2-9.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       roland@redhat.com, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] signal: make group kill signal fatal
References: <1243198054-13816-1-git-send-email-jirislaby@gmail.com> <20090525000750.GA2301@redhat.com>
In-Reply-To: <20090525000750.GA2301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2009 02:07 AM, Oleg Nesterov wrote:
> On 05/24, Jiri Slaby wrote:
>>
>> __fatal_signal_pending() returns now true only for a non-group sent
>> sigkill, i. e. for example tgkill, send_sig...
> 
> No. Please look at complete_signal(). If we queue a fatal signal,
> we always add SIGKILL to any thread.

Ah, thanks. But it looks like it doesn't work well in some cases.
Consider this kernel code:

#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <linux/module.h>
#include <linux/poll.h>
#include <linux/sched.h>

static int release(struct inode *ino, struct file *file)
{
        unsigned int a;
        printk(KERN_DEBUG "fst\n");
        for (a = 0; a < 10; a++) {
                printk(KERN_DEBUG "%s: SP=%u FSP=%u pend=%.16lx
shpend=%.16lx\n",
                                __func__,
                                signal_pending(current),
                                fatal_signal_pending(current),
                                current->pending.signal.sig[0],

current->signal->shared_pending.signal.sig[0]);
                if (fatal_signal_pending(current))
                        break;
                msleep(1000);
        }
        printk(KERN_DEBUG "done\n");
        return 0;
}

static DECLARE_WAIT_QUEUE_HEAD(wq);

static unsigned int poll(struct file *file, struct poll_table_struct *p)
{
        poll_wait(file, &wq, p);

        return 0;
}

static const struct file_operations fops = {
        .owner = THIS_MODULE,
        .release = release,
        .poll = poll,
};

static struct miscdevice m = {
        .minor = MISC_DYNAMIC_MINOR,
        .name = "m",
        .fops = &fops,
};

static int init1(void)
{
        return misc_register(&m);
}

static void exit1(void)
{
        misc_deregister(&m);
}

module_init(init1);
module_exit(exit1);

MODULE_LICENSE("GPL");






----------------------------------------------
And this user code:
#include <err.h>
#include <fcntl.h>
#include <poll.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char **argv)
{
        struct pollfd fds = { .events = POLLIN };
        int fd;

        fd = open("/dev/m", O_RDONLY);
        if (fd < 0)
                err(1, "open");
        fds.fd = fd;
        if (poll(&fds, 1, -1) < 0)
                err(2, "poll");
        close(fd);
        return 0;
}






----------------------------------------------
It outputs:
fst
release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100
release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100
release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100
release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100
release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100
release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100
release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100
release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100
release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100
release: SP=1 FSP=0 pend=0000000000000000 shpend=0000000000000100
done

I.e. it won't get propagated to current->pending. Don't you have idea
why? If the poll isn't there, it works well.

glibc 2.9, x86_64
