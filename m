Return-Path: <linux-kernel-owner+w=401wt.eu-S1757785AbYEKSZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbYEKSZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYEKSYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:24:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:53690 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbYEKSYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=kzjitd3RKiO1kzVo+cFShWDJTV72AdIXt3yMVmbdjPq4stj1X210arFvy13cR4kDy0xyvPNxRw0gCXMGzMLR97leFWDzjPjtr3Y+Cxg0tFuI5cYkDxAd7vj+CXKz5blbCSXSJVpCT3zjJLWLYcfy2WTLysg3mGbumVmA2NQ9sbg=
Date: Sun, 11 May 2008 22:24:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before
	`.text'
Message-ID: <20080511182440.GC6942@cvg>
References: <18470.787.498329.144701@harpo.it.uu.se> <482604D1.7020804@zytor.com> <20080510211602.GA32339@uranus.ravnborg.org> <20080511154411.GB6942@cvg> <482737A8.4040602@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482737A8.4040602@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Sun, May 11, 2008 at 11:15:04AM -0700]
> Cyrill Gorcunov wrote:
>> Should not it be something like
>> ---
>> diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S 
>> b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
>> index 22fab6c..cccf62d 100644
>> --- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
>> +++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
>> @@ -12,11 +12,6 @@ ENTRY(_start)
>>   SECTIONS
>>  {
>> -	. = HEADER_OFFSET;
>> -	.header : {
>> -		 *(.header)
>> -	}
>> -
>>  	. = 0;
>>  	.text : {
>>  		 *(.text*)
>> @@ -53,6 +48,11 @@ SECTIONS
>>  	. = ALIGN(16);
>>  	_end = .;
>>  +	. = HEADER_OFFSET;
>> +	.header : {
>> +		 *(.header)
>> +	}
>> +
>>  	/DISCARD/ : {
>>  		*(.note*)
>>  	}
>> ---
>> 		- Cyrill -
>
> Yes.  This was the way I originally had it, then Pavel decided to move the 
> header to the end.
>
> 	-hpa
>

Hi Peter,

actually I only doubt about exactly position of this headers - I mean
meguess it better should be _before_ "_end" not after. Since the others
script uses (acpi/wakeup_rm.S):

	wakeup_code_start:
	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
	wakeup_code_end:

and kernel uses these wakeup_code_* marks to save/restore memory I think
it should be like

	. = HEADER_OFFSET;
	.header : {
		...
	}
	. = ALIGN(16);
	_end = .;
	/DISCARD/ ...

		- Cyrill -
