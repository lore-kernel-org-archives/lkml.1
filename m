Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbZDGHot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbZDGHot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZDGHoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:44:37 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12132 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZDGHoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:44:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=kuobiNueV3DkDdLPhUoeSEAcnY6Ywrihvyo9HfHij4yMv3ImUiGCIT6t6s8GDsAE+
	xI9Pcx4gRPh5+Xg0ACibQ==
Date: Tue, 7 Apr 2009 00:44:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Brice Goglin <Brice.Goglin@inria.fr>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Chris Worley <worleys@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Off topic: Numactl "distance" wrong
In-Reply-To: <20090407070530.GJ17934@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.0904070035570.20262@chino.kir.corp.google.com>
References: <86802c440904031448yc6d499ckd9cb969ce136f477@mail.gmail.com> <87r609jtc2.fsf@basil.nowhere.org> <20090407111539.F0F5.A69D9226@jp.fujitsu.com> <49DAF003.1070605@inria.fr> <20090407070530.GJ17934@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Andi Kleen wrote:

> I'm not aware of any that does. In general applications usually
> only use the bare basics of NUMA API (if at all), the fancy stuff tends
> to be more slideware.
> 
> If it's true then the correct place would be to fix the BIOS.
> 

We already verify that each node has local distance to itself and that its 
distance to any other node is greater than local when determining whether 
the SLIT is valid.

It would also be possible to verify that the distance between two 
localities is described consistently in the table (like in the following 
patch).

I do think it would be helpful to add an acpi=noslit option, however, that 
would disable parsing the SLIT if it is known to incorrectly describe the 
physical topology of the system.
---
diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -172,6 +172,8 @@ static __init int slit_valid(struct acpi_table_slit *slit)
 					return 0;
 			} else if (val <= LOCAL_DISTANCE)
 				return 0;
+			if (val != slit->entry[d*j + i])
+				return 0;
 		}
 	}
 	return 1;
