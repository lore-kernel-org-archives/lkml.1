Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZCJF5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZCJF5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZCJF5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:57:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:23230 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbZCJF5X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AOji4mwmrlnnE9oEf8T7apymXNlD+bHyAKW7NmHJd93zGlX3VRWMuSe/TizZasi1PB
         akUDEZMmAR2bFBuFJPrOrg7tG7uAQem6hF+p+AH7ozGwWvopGpzwkCn80GOuEAPgMTvz
         5fanBeYOCaAhK1kM+JIm7Oz4TjX3XS/kJymDg=
MIME-Version: 1.0
In-Reply-To: <20090310053721.GA25977@uranus.ravnborg.org>
References: <49B5AD6A.2020101@goop.org> <49B5C12B.1020108@kernel.org>
	 <20090310053721.GA25977@uranus.ravnborg.org>
Date: Mon, 9 Mar 2009 22:57:19 -0700
X-Google-Sender-Auth: 5f58fc83c022f000
Message-ID: <86802c440903092257i4b95b13evaabf50409b770113@mail.gmail.com>
Subject: Re: Absolute symbols in vmlinux_64.lds.S
From: Yinghai Lu <yinghai@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 9, 2009 at 10:37 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, Mar 09, 2009 at 06:23:55PM -0700, Yinghai Lu wrote:
>> Jeremy Fitzhardinge wrote:
>> > Why does vmlinux_64.lds.S use absolute symbols for things like
>> > __bss_start/stop:
>> >
>> >  __bss_start = .;        /* BSS */
>> >  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
>> >     *(.bss.page_aligned)
>> >     *(.bss)
>> >     }
>> >  __bss_stop = .;
>> >
>> >
>> > vmlinux_32.lds.S puts __bss_start/stop into the .bss section itself.  Is
>> > there some particular reason they need to be absolute symbols
>> > (relocation?).
>> >
>>
>> they are the same.
>
> Thats depends on the value of '.' where you assign __bss_start.
> We have had several bugs where the symbol assinged outside the
> section was less than expected because the linker aling the
> start of the section equal to the lrgest alignment requirement
> of a member in the section.
>
> So in this case if '.' equals to 0xabcd and the lagest
> alignment requirement inside the block is 0x1000 and we have
> __bss_start1 = .;
> .bss : {
>        __bss_start2 = .;
>        *(.bss.page_aligned)
> }
>
> Then you would see that:
> __bss_start1 equals 0xabcd
> __bss_start2 equals 0xb000

good to know...

anyway, more lines

  . = ALIGN(PAGE_SIZE);
  __nosave_begin = .;
  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
      *(.data.nosave)
  } :data.init2 /* use another section data.init2, see PERCPU_VADDR() above */
  . = ALIGN(PAGE_SIZE);
  __nosave_end = .;

  __bss_start = .;              /* BSS */
  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
        *(.bss.page_aligned)
        *(.bss)
        }
  __bss_stop = .;

  _end = . ;


there are extra ALIGN(PAGE_SIZE) between them....

YH
