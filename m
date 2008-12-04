Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYLDBcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYLDBcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYLDBcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:32:13 -0500
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:48073
	"EHLO QMTA01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623AbYLDBcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:32:12 -0500
X-Authority-Analysis: v=1.0 c=1 a=h9d_Gi0u-OkA:10 a=JM--fFyA78oA:10
 a=jPTJJg5Q2a05fH43HIEA:9 a=7Ydq9ewFT6xCa7rfx6YA:7
 a=jNrqYWVDzc_1BRxaOzRtSQL_zTUA:4 a=c5zHXd76wwQA:10
Date: Wed, 3 Dec 2008 20:28:39 -0500 (EST)
From: "Brian S. Julin" <bri@abrij.org>
To: akpm@linux-foundation.org
cc: lenb@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com,
       linux-acpi@vger.kernel.org, mjg59@srcf.ucam.org
Subject: Re: [PATCH] misc: Add oqo-wmi driver for model 2 OQO backlight and
 rfkill control
In-Reply-To: <20081203150019.7e272c19.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0812031931240.2166@sheavy.abrij.org>
References: <20081127190517.GA25429@srcf.ucam.org>
 <alpine.LFD.2.00.0811281431320.3204@localhost.localdomain>
 <Pine.LNX.4.64.0811282215160.17453@sheavy.abrij.org> <20081129045045.GA13866@srcf.ucam.org>
 <20081203195537.GB22560@srcf.ucam.org> <20081203150019.7e272c19.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yeah Matthew picked up the code before I did a final cleanup, at that
point I was still just waiting for someone(anyone) to test it.  So the edges are
rough and there's still some painter's tape stuck to the walls.  I guess I 
can afford some time to shave the fuzzies off, but Matthew and I should 
coordinate timewise if this all needs to be fixed before it's in a repository -- 
my opportunities to code are sparse, and his attention is probably a highly 
contested resource.

Thanks for the review (and Sven in other reply, too) -- a few items I 
probably would have missed cleaning.  Some stuff is the wmi core 
and sample drivers at least as they were when I coded, and those aren't 
from me.

On Wed, 3 Dec 2008, Andrew Morton wrote:
>> +static int smread_s16(u8 hi_addr, u8 lo_addr)
>> +{
>> +	s16 ret = -1;
>> +	acpi_status status;
>> +	u8 r;
>> +
>> +	/* Keep some ACPI routines off the SMBUS */
>> +	status = oqo_lock_smbus(1);
>> +	if (ACPI_FAILURE(status))
>> +		goto skip;
>
> Does this mean that we didn't take the lock?  If so, will running
> oqo_lock_smbus(0) be correct?

That does this (in DSL) after unpacking arguments and running a switch statement:

             Store (BUF1, VFLG)
                     Return (0x00)

...VFLG being a preallocated RAM value in the ACPI VM.  That's all.  Famous last 
words but I really don't see it failing ever, or if it does the ACPI VM's in
deep doodoo anyways.  At any rate it will not spin.

Really an ACPI doctor is needed to even explain why it's there at all -- 
there's a real mutex on the SMBUS, and this here is not it.

It seems to just be some sort of badly coded (in DSDT) advisory that keeps the 
machine awake.  I only even bothered to call it because it seemed like safer to 
do so than not.  We should really be the only writer, as ACPI routines merely 
read it (and only a few of them.)  The only access to it is through the WMI 
interface.  Can we just claim exclusivity on using that given this is an 
omnibus driver?

> This driver does quite a lot of casting of things which the compiler
> will happily do for us.  This could be viewed as having documentation
> benefit, but not much, and it is atypical.

Yep I know, I'm cast-and-paren trigger happy.  Keeps me sane, and has saved
my butt a few times, but can be cleaned to match style.

P.S. I think it was Sven that pointed out a

label:
  return

IIRC that was due to a cranky GCC warning FWIW.

--
Brian
