Return-Path: <linux-kernel-owner+w=401wt.eu-S933826AbYF3WST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbYF3WST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283AbYF3WSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:18:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752AbYF3WSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:18:01 -0400
Message-ID: <48695ACE.9040806@zytor.com>
Date: Mon, 30 Jun 2008 15:14:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Sean Young <sean@mess.org>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com>
In-Reply-To: <48695871.8000805@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>>>
>>> startup_32:
>>>         cld
>>>         /* test KEEP_SEGMENTS flag to see if the bootloader is asking
>>>          * us to not reload segments */
>>>         testb $(1<<6), BP_loadflags(%esi)
>>>         jnz 1f
>>>
>>>         cli
>>>         movl $(__BOOT_DS),%eax
>>>         movl %eax,%ds
>>>         movl %eax,%es
>>>         movl %eax,%fs
>>>         movl %eax,%gs
>>>         movl %eax,%ss
>>> 1:

On this general subject... I keep thinking that it would be better to 
have this as:

	movl	%cs, %eax
	addl	$8, %eax
	movl	%eax, %cs

... instead of a hard-coded constant.  That actually removes all 
hard-coded uses of BOOT_CS/BOOT_DS until we eventually load the kernel's 
own boot GDT at head_32.S:94.

Does anyone see any problem with that?  As far as I can tell, we're 
requiring %cs == BOOT_CS for the current code anyway (unless 
KEEP_SEGMENTS), but %ds == %cs + 8 seems like a more sensible requirement.

	-hpa
