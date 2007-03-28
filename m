Return-Path: <linux-kernel-owner+w=401wt.eu-S964862AbXC1Rc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbXC1Rc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965052AbXC1Rc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:32:58 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51272 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXC1Rc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:32:57 -0400
Date: Wed, 28 Mar 2007 10:32:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Robin Holt <holt@sgi.com>, David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v4
Message-Id: <20070328103223.0473efc3.akpm@linux-foundation.org>
In-Reply-To: <460A6173.9040808@hitachi.com>
References: <45E7AAFA.4070402@hitachi.com>
	<20070315133721.ecbec123.akpm@linux-foundation.org>
	<4603D281.1000101@hitachi.com>
	<460A6173.9040808@hitachi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 21:37:07 +0900 "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com> wrote:

> >   Because other people might (reasonably) wish to omit anonymous memory,
> >   or private mappings, or file-backed VMAs, or whatever.
> > 
> >   So maybe /proc/pid/coredump_omit_anon_shared should become
> >   /proc/pid/core_dumpfilter, which is a carefully documented bitmask.
> 
> There are people who wish to dump VMAs which are not dumped by default.
> Taking this into account, some bits of core_dumpfilter will be set by
> default.  This means users have to be aware of the default bitmask
> when they change the bitmask.  Perhaps changing the bitmask requires
> 3 steps:
> 
>   1. read the default bitmask
>   2. change bits of the mask
>   3. write it to the proc entry
> 
> So I think it is better if we provide /proc/pid/core_flags (default:
> all bits are 0) instead of core_dumpfilter.  With this interface,
> users who use only one bit of the bitmask (this will be a common case) 
> just have to write 2^n to the proc entry.  It takes only one step:
> 
>  1. write a value to the proc entry
> 
> If we can implement at the same cost, core_flags will be better
> because it is useful for users.  What would you think about that?
> 

It sounds unnecessarily complex, and unnecessarily different from our
normal expectations of /proc files.  And the value we read differs from the
value we wrote...  I think having a non-zero default will be fine.

> 
> By the way, Robin Holt wrote as follows:
> 
> > Can you make this a little more transparent?  Having a magic bitmask does
> > not seem like the best way to do stuff.  Could you maybe make a core_flags
> > directory with a seperate file for each flag.  It could still map to a
> > single field in the mm, but be broken out for the proc filesystem.
> 
> Do you think Robin's suggestion is acceptable?

Marginal, I think.  This is not likely to be a field which a lot of people
modify a lot of times.  Those few people who need to work with this can
afford to look the values up in the documentation while writing their
script.

And it requires a distressingly large amount of code to implement a /proc
file.  Perhaps in this situation the code can be shared.

otoh, why is it a /proc thing at all?

unsigned long sys_set_corefile_filter(unsigned long enable_mask);
unsigned long sys_clear_corefile_filter(unsigned long enable_mask);

would be better?
