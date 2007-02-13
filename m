Return-Path: <linux-kernel-owner+w=401wt.eu-S1750738AbXBMPVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750738AbXBMPVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 10:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXBMPVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 10:21:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:38751 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXBMPVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 10:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=VLAbhyrRoTN7/FePKHJc2YgcTzHxqHAIFa6DOUdfDLsvGOAEglcLQFiMU55fZjuWRQWYc4lGQXqAeSbQEMbyw0CC/3x+qhydI6OCXnh26ZmNXHWK0DBI2InWLA+hF0Jed5GiY6DLBd5Px/ZI5+GkYjHcJ32xkbBs3CUXy3m2ofc=
Message-ID: <45D1D72D.9020509@gmail.com>
Date: Tue, 13 Feb 2007 07:20:13 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net
Subject: Re: libata FUA revisited
References: <fa.S80SRyQbD/hm4SxliPUKU88BaCo@ifi.uio.no> <fa.Q/csgyCHkAsD84yi+bN78H1WNNM@ifi.uio.no> <45D104F3.7040602@shaw.ca>
In-Reply-To: <45D104F3.7040602@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Robert.

Robert Hancock wrote:
[--snip--]
> On the NCQ side, I think it's pretty safe to assume that all controllers 
> will handle it. Obviously I've verified it with sata_nv (at least that 
> it doesn't blow up obviously), and the other two NCQ drivers we have, 
> ahci and sata_sil24 just feed raw FIS data into the controller so there 
> should be no issue with not supporting it.

FWIW, ICH6/7/8 ahci's clear PMP field when transmitting FIS.  The reason 
why I'm hesitant is because there is no way to tell whether the FUA bit 
got honored or ignored.  With extra opcode, it's okay because barrier 
explicitly fails but if NCQ FUA is not supported, it will succeed 
silently as normal write.  Everything will be okay generally but the 
barrier is done incorrectly and on a really bad day it will lead to 
journal corruption.

So, actually, I was thinking about *always* using the non-NCQ FUA 
opcode.  As currently implemented, FUA request is always issued by 
itself, so NCQ doesn't make any difference there.  So, I think it would 
be better to turn on FUA on driver-by-driver basis whether the 
controller supports NCQ or not.

Well, I might be being too paranoid but silent FUA failure would be 
really hard to diagnose if that ever happens (and I'm fairly certain 
that it will on some firmwares).

-- 
tejun
