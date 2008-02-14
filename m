Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbYBNXBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbYBNXBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbYBNXBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:01:47 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:11753 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYBNXBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:01:46 -0500
Date: Fri, 15 Feb 2008 00:01:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       torvalds@osdl.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       ying.huang@intel.com
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080214230138.GA1014@basil.nowhere.org>
References: <20080214131317.GA27769@basil.nowhere.org> <20080214161218.GA28152@elte.hu> <20080214171603.GC16255@one.firstfloor.org> <20080214183819.GA19846@elte.hu> <20080214214241.GB19473@one.firstfloor.org> <20080214140816.68b47407@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214140816.68b47407@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Feb 2008 22:55:15.0728 (UTC) FILETIME=[A9D8A100:01C86F5C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 02:08:16PM -0800, Arjan van de Ven wrote:
> On Thu, 14 Feb 2008 22:42:41 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Thu, Feb 14, 2008 at 07:38:19PM +0100, Ingo Molnar wrote:
> > > 
> > > * Andi Kleen <andi@firstfloor.org> wrote:
> > > 
> > > > > this is indeed a bug (we change the attributes for a larger
> > > > > area than needed), but your fix is unclean. Find below a
> > > > > cleaner solution.
> > > > 
> > > > You're still ignoring the other problem of set_memory_uc() not 
> > > > handling fixmap and ioremap correctly. [...]
> > > 
> > > No, we did not ignore it, and yes, you are wrong.
> > > 
> > > One thing that you miss is that the 64-bit EFI runtime has to be
> > > marked uncacheable only if it the EFI image attribute signals an
> > > uncacheable area:
> > > 
> > >                 if (!(md->attribute & EFI_MEMORY_WB))
> > >                         set_memory_uc(md->virt_addr, md->num_pages);
> > > 
> > > and Linux EFI does not support device EFI runtimes. So your
> > > observation, 
> > 
> > Sorry I didn't get that (you were a bit terse). 
> > 
> > You're saying the EFI BIOSes will never set that flag ?
> > 
> > I'm reading page 123+ of UEFI 2.1 which describes GetMemoryMap() 
> > and these flags and I see nothing to that effect. I admit I didn't
> > read the full EFI bible so far so there are certainly EFI
> > aspects I don't understand.
> > 
> > Can you please clarify why EFI would not set that flag on Linux?
> 
> because it will only normally 

normally or guaranteed? 

e.g. possible scenario: one of the EFI runtime services needs
access to some device to do something (e.g. for rebooting
or putting information into the battery backed RAM). Wouldn't they likely 
provide a UC mapping to that device's memory using this flag? 

> get set on EFI code that lives in device memory.

Ok but what prevents the firmware from passing such memory areas?
I assume it doesn't know that Linux doesn't need such mappings, does it?

Anyways if all the questions above get firmly answered with no then the code 
setting mappings UC should be definitely removed.  I would welcome such
a patch.

-Andi

