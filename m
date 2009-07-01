Return-Path: <linux-kernel-owner+w=401wt.eu-S1750917AbZGAOsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbZGAOsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZGAOr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:47:56 -0400
Received: from ey-out-1920.google.com ([74.125.78.150]:34510 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZGAOrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=o3+PSpFA+j+eYw1yTE5Kpuxxy/rYYIziPjmwBJpmvkVUPmoesqGv5WwL3Z+DEjh8sG
         6Q6ye8360b/te59wO42BHjN8/N3oh673EpIR6w/UDLVHSm0xGwpnQWcSTUp/yJ6EIjsN
         kE7me3OtPrpiiSZ1HaiF9EFpeG7xTKDAxQ5ZY=
Subject: Re: [Bug #13663] suspend to ram regression (IDE related)
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Etienne Basset <etienne.basset@numericable.fr>,
       David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       bzolnier@gmail.com, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, linux-ide@vger.kernel.org
In-Reply-To: <b6a2187b0907010731k510150b5u1c7fce8cbed7c33b@mail.gmail.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera>
	 <5Hhc7UkUKEO.A.RvE.BjASKB@chimera> <4A489775.6020102@numericable.fr>
	 <20090629.033730.193709457.davem@davemloft.net>
	 <4A48E307.2010208@numericable.fr>
	 <b6a2187b0906290921w15afd443qccb943ccfd48688b@mail.gmail.com>
	 <b6a2187b0907010731k510150b5u1c7fce8cbed7c33b@mail.gmail.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Wed, 01 Jul 2009 22:47:41 +0800
Message-Id: <1246459661.9660.40.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 22:31 +0800, Jeff Chua wrote:
> On Tue, Jun 30, 2009 at 12:21 AM, Jeff Chua<jeff.chua.linux@gmail.com> wrote:
> 
> > I just tried, and it "seems" to work. Will try a few more cycles.
> 
> STD/STR survived quite a few cycles now. Patch seems to be doing the
> right thing.
> 
> On Mon, Jun 29, 2009 at 11:51 PM, Etienne
> Basset<etienne.basset@numericable.fr> wrote:
> 
> > To have STR/resume work with current git, I have to :
> 
> > 1) apply Bart's patch
> 
> This is not yet in Linus's tree. And much needed to really fix the problem.
> 
> > 2) revert this commit : a1317f714af7aed60ddc182d0122477cbe36ee9b
> 

Yes, This commit must be reverted, otherwise, STD/Hibernation will not
work either. I have tested it on two different loongson-based machines:
fuloong2e box and yeeloong2f netbook.(loongson is mips compatiable)

Here is what i have traced:

        hibernate(kernel/power/hibernate.c)
        --> hibernation_snapshot
        --> dpm_resume_end
        --> dpm_resume
        --> device_resume
        --> dev->bus->resume(generic_ide_resume), dev_name(dev) = 0.0
        --> blk_execute_rq
        {
                DECLARE_COMPLETION_ONSTACK(wait);
                ...
                wait_for_completion(&wait);     // stop here
                ...
        }

and I have tried to revert this part of the above patch:

-
-               WARN_ON_ONCE(hwif->rq);
 repeat:
                prev_port = hwif->host->cur_port;
+
+               if (drive->dev_flags & IDE_DFLAG_BLOCKED)
+                       rq = hwif->rq;
+               else
+                       WARN_ON_ONCE(hwif->rq);
+

it works! need more time to test!

thanks!
Wu Zhangjin

