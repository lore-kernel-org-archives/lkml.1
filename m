Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbYIKPFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbYIKPFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYIKPFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:05:42 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:57249 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYIKPFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:05:41 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48C933C2.3070906@avtrex.com>
Date: Thu, 11 Sep 2008 08:05:38 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch 2/6] MIPS: Add HARDWARE_WATCHPOINTS definitions and support
 code.
References: <48C8ADEF.9020305@avtrex.com> <48C8B2C3.4050002@avtrex.com> <Pine.LNX.4.64.0809110922090.29543@anakin>
In-Reply-To: <Pine.LNX.4.64.0809110922090.29543@anakin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2008 15:05:39.0101 (UTC) FILETIME=[DA040CD0:01C9141F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Wed, 10 Sep 2008, David Daney wrote:
> 
> Given
> 
>> +	case 4:
>> +		write_c0_watchlo3(watches->watchlo[3]);
>> +		/* Write 1 to the I, R, and W bits to clear them, and
>> +		   1 to G so all ASIDs are trapped. */
>> +		write_c0_watchhi3(0x40000007 | watches->watchhi[3]);
>> +	case 3:
>> +		write_c0_watchlo2(watches->watchlo[2]);
>> +		write_c0_watchhi2(0x40000007 | watches->watchhi[2]);
>> +	case 2:
>> +		write_c0_watchlo1(watches->watchlo[1]);
>> +		write_c0_watchhi1(0x40000007 | watches->watchhi[1]);
>> +	case 1:
>> +		write_c0_watchlo0(watches->watchlo[0]);
>> +		write_c0_watchhi0(0x40000007 | watches->watchhi[0]);
> 
> and
> 
>> +	case 4:
>> +		watches->watchhi[3] = (read_c0_watchhi3() & 0x0fff);
>> +	case 3:
>> +		watches->watchhi[2] = (read_c0_watchhi2() & 0x0fff);
>> +	case 2:
>> +		watches->watchhi[1] = (read_c0_watchhi1() & 0x0fff);
>> +	case 1:
>> +		watches->watchhi[0] = (read_c0_watchhi0() & 0x0fff);

[...]

> do the same for each registers, perhaps it makes sense to create
> read_c0_watchhi(), write_c0_watchlo(), and write_c0_watchhi() macros
> that take the watchdog register index as a parameter? Then the above can
> be turned in simple loops.

I thought that too when I first started looking at it, but the
{read,write}_c0_watchhi{0,1,2,3,4,5,6,7} macros expand to a single
machine instruction.  The bit pattern of the instruction is determined
at compile time, so you would need something like the switch statement
somewhere.  Explicitly showing it in the code seemed as good as hiding
the complexity in some macro or access function.

[...]

>> +	c->watch_reg_count = 7;
>> +	t = read_c0_watchhi6();
>> +	if ((t & 0x80000000) == 0)
>> +		return;
>> +
>> +	c->watch_reg_count = 8;
> 
> and here
> 
> BTW, no check for read_c0_watchhi7()?
> 

The current patch uses a maximum of four register sets, since we are
only reporting the number of sets, we don't care about the
characteristics of watchhi[7] and thus don't need to read it.

Thanks,
David Daney
