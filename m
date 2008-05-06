Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYEFLvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYEFLvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYEFLvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:51:04 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:57895 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYEFLvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:51:02 -0400
Message-ID: <482045FF.8070109@de.ibm.com>
Date: Tue, 06 May 2008 13:50:23 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: ltp-list@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>,
       ltp-coverage@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] kernel: call constructors
References: <481F2694.5090601@de.ibm.com> <20080505195301.GB8868@uranus.ravnborg.org>
In-Reply-To: <20080505195301.GB8868@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, May 05, 2008 at 05:24:04PM +0200, Peter Oberparleiter wrote:
>> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>> +#define CONSTRUCTORS							\
>> +		__CTOR_LIST__ = .;					\
>> +		*(.ctors)						\
>> +		__CTOR_END__ = .;					\
>> +		__DTOR_LIST__ = .;					\
>> +		*(.dtors)						\
>> +		__DTOR_END__ = .;
> 
> You shall use:  VMLINUX_SYMBOL() here.

Ok, will do.

> And why those SHOUTING names?
> All other linker symbols are lowercase.

Here's the background for that: currently, almost all
arch/*/vmlinux.lds.S scripts contain reference to a CONSTRUCTORS
sections which is (as of yet) empty. The info pages for ld contain
a description of the contents of this section (section 3.6.6 Output
Section Keywords), including the following sample linker script:

                __CTOR_LIST__ = .;
                LONG((__CTOR_END__ - __CTOR_LIST__) / 4 - 2)
                *(.ctors)
                LONG(0)
                __CTOR_END__ = .;
                __DTOR_LIST__ = .;
                LONG((__DTOR_END__ - __DTOR_LIST__) / 4 - 2)
                *(.dtors)
                LONG(0)
                __DTOR_END__ = .;

Apparently this sample script is buggy (namely the divide by 4 bit on
64 bit systems) so I changed it into the version found in the patch.
This is somewhat of a trade-off between the information which
should be present in a CONSTRUCTORS section according to the info
page and what really is needed to implement constructor support.

I guess changing the names would be an option if required, as well
as dropping the (unused) destructor bit of the linker script.
