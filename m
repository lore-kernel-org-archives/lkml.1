Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbZBLOkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbZBLOkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbZBLOj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:39:59 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:51282 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744AbZBLOj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:39:58 -0500
Date: Thu, 12 Feb 2009 14:39:56 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: get/put unaligned helpers
In-Reply-To: <49941C4A.4050401@panasas.com>
Message-ID: <alpine.LFD.1.10.0902121353060.7279@ftp.linux-mips.org>
References: <20090211143521.GA18866@lst.de> <1234367339.5481.3.camel@brick> <4993E2CA.1070408@panasas.com> <alpine.LFD.1.10.0902121241570.7279@ftp.linux-mips.org> <49941C4A.4050401@panasas.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009, Boaz Harrosh wrote:

> I was under the impression they need to be aligned because otherwise that means
> something is done wrong. Because the aligned version on lots of CPUs is one instruction
> where unaligned access is better, or must, be emulated (byte accessed).
> 
> Assembly wise the two accesses are different and sometimes the compiler has no way to
> know, where the programmer can know for sure.
> 
> But I like to be educated any day, please explain what to use when.

 The compiler is always told by the programmer what alignment to expect -- 
the language defines the alignment of each data type it may use.  For 
example for integer types the alignment is always equal to the size of the 
type.  Casting a pointer and subsequently accessing data pointed at leads 
to undefined behaviour if it increases the required alignment -- you'll 
get a warning from GCC if you ask it for this class of warnings.  If you 
want to access this data anyway you have to tell the compiler the data is 
not correctly aligned.

 You can use packed structs (or unions) to ask GCC to emit code sequences 
suitable for accessing unaligned data entities of various sizes.  For 
example with the MIPS processor if a 32-bit-wide entity is read via a 
member of a packed type, a sequence consisting of an LWL (load word left) 
and an LWR (load word right) instruction will be generated to perform two 
complementing bus read cycles with byte enables appropriately set to fetch 
the two parts of the entity spanning a 32-bit alignment boundary.  
Normally a single LW (load word) instruction would be used to fetch the 
entity, but that instruction would trap if the address used to access it 
was not aligned.  For platforms where hardware is capable of doing 
unaligned accesses with no special treatment the use of packed types does 
not imply a change in the emitted code.

 Of course letting GCC sort out unaligned accesses itself has a lot of 
advantages, for example other instructions may get scheduled between the 
LWL and LWR mentioned above as GCC sees fit; the two have no special 
scheduling requirements with respect to each other (the reverse is 
actually the case -- care has been taken since the beginning of the 
architecture so that making them adjacent to each other is permitted and 
incurs no performance penalty), but other instructions which surround them 
may and making such a reorder may improve performance.  Such accesses may 
get merged or killed too as any other ones.

 Linux seems to put a lot of infrastructure around it, but in reality it 
is just a couple of lines of common code; I suppose it is there more to 
make people aware of the issue (all the world is not x86) than to invent 
something new.  And also Linux is a single program so it makes sense not 
to scatter duplicates and have local copies of the same code for each 
platform/subsystem/driver/etc.  You'd do the same with any other program, 
but promoting the couple of lines to become a system header sounds like an 
overkill to me.

  Maciej
