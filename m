Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbXEYL7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbXEYL7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXEYL7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:59:12 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:58340 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbXEYL7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cVKJ6WRMhOfXZWtHprFvZmdhTgqGZph0ErGC6oSF/MaqkZnn1OwUrIVLXPhumk1dcLWptWH946NBWqeTQ42uoHZclWFvlyjWji3gp7+6t4OjUSHoHhgOpKNNF7zhUGZSBXjg0II9YJEJmulwVHdpZ+q7DBedvNycwNIf815l/JE=
Message-ID: <4656CF83.5020402@gmail.com>
Date: Fri, 25 May 2007 13:58:59 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata: always use polling SETXFER
References: <20070314053338.GA15600@htj.dyndns.org> <4656C144.2080705@garzik.org>
In-Reply-To: <4656C144.2080705@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff.

Jeff Garzik wrote:
> Since I wrote them up in IRC, I might as well post them here and get it
> archived:

Just about to reply on IRC.  :-)

> We need to figure out a better polling solution.
> 
> For SAS and advanced SATA, polling really has no meaning at all, when
> you consider what polling IDENTIFY DEVICE and polling SET FEATURES are
> trying to solve.  To the advanced hardware, it's all a bunch of packets.
>  An event that appears "late" to the eyes of the PATA world is now
> presented as changing data fields in the packet stream.
> 
> We are going to have to deal with the HSM issue underlying the need to
> do SET FEATURES - XFER MODE polling, and ultimately IDENTIFY DEVICE
> polling too.
> 
> This is the main reason why I have resisted applying "[PATCH] libata:
> always use polling SETXFER" -- polling implies a model that does not
> exist on SAS/SATA and advanced SATA.  It's only luck that AHCI includes
> a real register to poll.
> 
> To illustrate:  Fixing this problem The Right Way(tm) will yield a
> result that would allow ahci.c to operate in an interrupt-driven mode,
> examining the contents of the FIS's returned. Polling status can already
> be replaced by examining the D2H and SDB FIS areas.
> 
> And by definition, on AHCI (and sata_sil24, IIRC) the status will not
> change unless a new FIS has arrived.
> 
> Polling is still fine on PCI IDE-like controllers (older ones), but
> advanced controllers require us to coalesce the polling bandaid into a
> test for a sequence of events.
> 
> We cannot escape the "hard part."  :)

I don't think the "hard part" exists at all.

1. There are only a handful of PATA devices which raise IRQ too early.
For native SATA devices, it's much more difficult to get it wrong if you
consider the SATA non-data and PIO transport protocol.  For PATA devices
bridged to SATA, again, there's nothing much we can do.  The bridge
implements HSM and would send D2H Reg FIS on command completion IRQ.  If
the PATA shows incorrect register values at that stage, well, that's it.

3. Intelligent controllers such as AHCI and sil24 implement some part of
HSM in the silicon.  sil24 implements most of it, ahci a bit less, but,
even for ahci, the too early interrupt can trigger internal HSM failure.
 I don't think we can do much in such cases.  sil24 doesn't even update
the TF area if command is not in progress.  In the intelligent
controllers, the problem polling SETXFER tries to solve is in lower
layer than OS driver.

So, I don't think the problem exists for SATA in the first place.  At
least there hasn't been any report of it and doing SETXFER by polling
can handle all the existing cases.  We can and probably should deal with
such SATA devices when and if they come up.  How are we gonna verify the
controller doesn't crap itself and ahci TF register monitoring HSM can
work around the weirdo when we don't have any such device?  Even if we
determine that we need to do HSM over intelligent SATA controller now, I
think we still need to push polling SETXFER first to take care of the
existing cases.

Thanks.

-- 
tejun
