Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbXCZDWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbXCZDWN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 23:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933498AbXCZDWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 23:22:13 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:47068 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933470AbXCZDWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 23:22:12 -0400
Message-ID: <46073B5D.9090505@hitachi.com>
Date: Mon, 26 Mar 2007 12:17:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       hch@infradead.org
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC][Patch 1/4] kprobe fast unregistration
References: <4603E7A4.50300@hitachi.com> <20070323180527.GA13728@bambi.jf.intel.com>
In-Reply-To: <20070323180527.GA13728@bambi.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph and Anil,

Thank you for your comments.

Christoph Hellwig wrote:
> Speeding up the unregistration is a very good idea, but this interface
> is rather horrible.  It's almost a receipe for users to get it wrong.
Keshavamurthy, Anil S wrote:
> I agree with Christop that the interface is horrible and error prone.

OK, I agree. I had chosen a confusable name.

> However, I see the use case where people want to disable the probes quickly and
> would like to reenable them again. Looking closely at your patch,
> I think this can be acheived.

Thank you.

> Here is my suggestion.
> 
>> Here is an example code.
>> --
>> struct kprobes *p;
>> for_each_probe(p) {
>> 	unregister_kprobe_fast(p);
>         ^^^^^^^^^^^^^^^^^^^^^^
> Change this to disable_kprobe(p), which is essentially the same as
> what you have implemented. And also provide an opposite function
> to reenable_kprobe(p) which enables the disabled probe again.

I'd like to change that to prepare_to_unregister_kprobe(p) instead of
disable_kprobe(p).

I think Josh and other people want interfaces to disable/reenable all
probes at once when the sysrq is pressed.
So, IMHO, these interfaces should use a global (and per-cpu?) flag which
controls whether kprobes calls user-defined handler or not, instead of
self-modifying.
For example,

if (p && p->pre_handler && kprobe_enable) {
                           ^^^^^^^^^^^^^
   ...
}

But, I think this would be another story.
I'd like to discuss this topic in other mails.

>> }
>> commit_kprobes();
>   ^^^^^^^^^^^^^^
> Change this to unregister_disabled_kprobes(), which essentially 
> unregisters all the disabled probes.

And also, I'd like to change it to unregister_prepared_kprobes().
What would you think about this idea?

Thanks,


> 
> Thanks,
> Anil Keshavamurthy
> 
-- 
Masami HIRAMATSU
Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


