Return-Path: <linux-kernel-owner+w=401wt.eu-S1764561AbXIUVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764561AbXIUVe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763037AbXIUVev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:34:51 -0400
Received: from smtpoutm.mac.com ([17.148.16.74]:51689 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763007AbXIUVeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:34:50 -0400
In-Reply-To: <200709201818.42125.rob@landley.net>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <59465.81.207.0.53.1190323573.squirrel@secure.samage.net> <200709201818.42125.rob@landley.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4477DB43-766B-4057-B33D-357A73AF69B0@mac.com>
Cc: Indan Zupancic <indan@nul.nu>, linux-tiny@selenic.com,
       Michael Opdenacker <michael@free-electrons.com>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [Announce] Linux-tiny project revival
Date: Fri, 21 Sep 2007 17:34:05 -0400
To: Rob Landley <rob@landley.net>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 20, 2007, at 19:18:41, Rob Landley wrote:
> On Thursday 20 September 2007 4:26:13 pm Indan Zupancic wrote:
>> But the problem remains that there are printk's which don't have a  
>> KERN_* as the first argument. Those are also impossible to get rid  
>> off in this way, as the loglevel is unknown (and you don't want  
>> partially printed messages).
>>
>> So adding the comma is really needed and in addition all printk's  
>> without a loglevel should get one. Which clutters the code and may  
>> increase codesize.
>
> It's ok to _explicitly_ not have a loglevel, and thus take a known  
> default.  The problem is printing out less than a full line,  
> continuing it later, and not making obvious at compile time what  
> the level of this chunk is.

That's actually a fairly straightforward problem to solve.  Really we  
ought to be able to guarantee that lines from different CPUs are not  
intermixed.  This can end up in a log like this:

info: Current device state: <1>netdev watchdog timeout: eth0
reg1=0xABCD reg2=0xDEADBEEF

Clearly unpleasant, no?  Really any logging which wants to print out  
a bunch of stuff with multiple printk()s should use an API something  
like this:

Option 1: Buffer allocated with kmalloc().  Sleep-ish context, can  
handle failures easily
> struct printk_queue qpk;
> if (qprintk_kmalloc(&qpk, level, GFP_KERNEL))
> 	return -ENOMEM;
>
> qprintk(&qpk, "Some string here:");
> qprintk(&qpk, " %d, %s, %d", 4, some_string, 42);
> qprintk_finish(&qpk);


Option 2: Preallocated per-cpu buffer.  preempt_disable()d
> struct printk_queue qpk;
> qprintk_percpu(&qpk, level);
> [...]
> qprintk_finish(&qpk);


Option 3: Preallocated per-cpu interrupts-only buffer.  Only from  
code which may interrupt a preempt_disable() section
> struct printk_queue qpk;
> qprintk_irq(&pqk, level)
> [...]
> qprintk_finish(&qpk);


For all of the above, the final "qprintk_finish()" call would  
essentially take the printk spinlock and write the contents of the  
qpk->buffer into the dmesg ringbuffer, inserting ("<%d>", level) at  
the beginning and after each newline.  The buffers would all be some  
useful fixed size (a page?); if you need more than that then you are  
probably trying to queue too much and excess data would be truncated.

Since the level would be a constant passed to qprintk_ 
{kmalloc,percpu,irq} in almost every case, you could easily do  
something like this:

static inline int qprintk_kmalloc(struct printk_queue *qpk,
		unsigned int level, gfp_t gfp)
{
	if (level > CONFIG_MAX_LOG_LEVEL) {
		qpk->type = QPRINTK_TYPE_NONE; /* also 0 */
		qpk->buffer = NULL;
		return 0;
	}

	_qprintk_kmalloc(qpk, level, gfp);
}

#define qprintk(QPK, FMT...) do { \
		if ((QPK)->type)
			_qprintk(QPK, FMT);
	} while(0)


With a bit more glue that would cause GCC to notice that for a given  
qprintk_kmalloc the "qpk->type" is always zero because the level is  
too high, and therefore it would optimize out *ALL* of the  
_qprintk_kmalloc(), _qprintk(), and _qprintk_finish() calls.

Cheers,
Kyle Moffett

