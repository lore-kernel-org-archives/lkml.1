Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZFOG0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZFOG0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbZFOGZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:25:57 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:35754 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZFOGZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YenrReqLgXZTGx8ohG29TujrCzqzonAZLmBcVWwX+JzbcpP3Xke031AAu0Vyhs+khe
         7VLqCTjg2rPSH5MTWdYKDL+9ailLR1UP4Q1zMFuh9kLTf5jkiys74NB98jUWzCTXVk6C
         Lq7YV9mJ0bL2fqkk9cCp7Gbc3Vyy8NVjE/bzU=
MIME-Version: 1.0
In-Reply-To: <1244995752.31584.69.camel@falcon>
References: <1244623722-6325-2-git-send-email-vapier@gentoo.org> 
	<1244667129-27630-1-git-send-email-vapier@gentoo.org> <1244992206.31584.59.camel@falcon> 
	<8bd0f97a0906140845o73c4c9d6r40c2e1132a46fa6a@mail.gmail.com> 
	<1244995752.31584.69.camel@falcon>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 15 Jun 2009 02:25:39 -0400
Message-ID: <8bd0f97a0906142325k68f21b73tce68c5fe9a553ee8@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] ftrace: document basic ftracer/ftracer graph needs
To: wuzhangjin@gmail.com
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 12:09, Wu Zhangjin wrote:
>> >> +For information on how to implement prepare_ftrace_return(), simply look at
>> >> +the x86 version.  The only architecture-specific piece in it is the setup of
>> >> +the fault recovery table (the asm(...) code).  The rest should be the same
>> >> +across architectures.
>> >> +
>> >
>> > and the fault recovery table is not needed.
>>
>> i dont have one for the Blackfin port, but that's more because there
>> is no fault recovery support in the Blackfin port ;)
>>
>> > In reality, the prepare_ftrace_return() can have the same arguments as
>> > ftrace_trace_function()
>> > ...
>> > as i know, prepare_ftrace_return() is used to check whether the calling
>> > function expect to trace, if yes, return the 'hook' function
>> > &return_to_handler, otherwise, return back to the parent_ip directly.
>> > so, here, i think there is no need to transfer the data via address, but
>> > just using the same arguments like ftrace_trace_function does.
>>
>> hmm, that would make the implementation simpler, but i dont think you
>> could do that if you implemented the fault handler.  i cant really
>> speak as to the requirement of the fault handler as i dont really know
>> what/how it works -- i can only guess at they arent used in any way
>> for Blackfin systems.
>>
>> > unsigned long
>> > prepare_ftrace_return(unsgined long ip, unsigned long parent_ip)
>> > {
>> >    [...]
>> >    if (ftrace_push_return_trace(parent_ip, ip, &trace.depth) == -EBUSY)
>> >        return parent_ip;
>> >
>> >    if (ftrace_graph_entry(&trace))
>> >        return (unsigned long)&return_to_handler;
>> >
>> >    [...]
>> >
>> >    return parent_ip;
>> > }
>> >
>> > if using the above method, the fault recovery table is not needed again.
>>
>> and it would allow us to move this code into the common ftrace
>> framework for people who dont do fault handlers.
>
> Perhaps I miss something here? otherwise, this fault handler is not
> needed if not transfer the data via address and not modify the data in
> the place *address accordingly.

this is based on my understanding of things, but really ive never
worked with a mmu before, so ive never had to deal with fault handlers
...

in order for ftrace graph to work, the return address has to be
modified to point to the arch-specific return_to_handler function.  it
doesnt matter where this modification occurs -- whether in the C
prepare_ftrace_return() or in the arch assembly function calling
prepare_ftrace_return().

the fault handler is there in case this modification fails for any
reason.  it doesnt matter if the code is restoring the old address in
case one of the common ftrace functions returns an error (stack depth
full/whatever).
-mike
