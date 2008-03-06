Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbYCFAv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbYCFAv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbYCFAvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:51:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbYCFAvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:51:17 -0500
Message-ID: <47CF3F09.4080606@zytor.com>
Date: Wed, 05 Mar 2008 16:47:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Chris Lattner <clattner@apple.com>
CC: Michael Matz <matz@suse.de>, Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com>
In-Reply-To: <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Lattner wrote:
>>>> Richard Guenther wrote:
>>>>> We didn't yet run into this issue and build openSUSE with 4.3 since 
>>>>> more
>>>>> than
>>>>> three month.
>>>>
>>>> Well, how often do you take a trap inside an overlapping memmove()?
>>>
>>> How hard is it to change the kernel signal entry path from "pushf" to
>>> "pushf;cld"?  Problem solved, no?
>>
>> The problem is with old kernels, which by definition stay unfixed.
> 
> My impression was that the problem occurs in GCC compiled code in the 
> kernel itself, not in user space:

That's wrong.

The issue is that the kernel is entered (due to a trap, interrupt or 
whatever) and the state is saved.  The kernel decides to revector 
userspace to a signal handler.  The kernel modifies the userspace state 
to do so, but doesn't set DF=0.

Upon return to userspace, the modified state kicks in.  Thus the signal 
handler is entered with DF from userspace at trap time, not DF=0.

So it's an asynchronous state leak from one piece of userspace to another.

	-hpa
