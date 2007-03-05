Return-Path: <linux-kernel-owner+w=401wt.eu-S933631AbXCEVf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631AbXCEVf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbXCEVf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:35:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:44149 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933633AbXCEVfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:35:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KvT6lsnaRI4aGFu7syYwPbOSZxW+zxmY25hrM3jwf85hFXH27GpBFv/Ecqr7IoUX9e+BpWZtgdSa0Lm8iop+etB6p+ns5v7NdD99qGHDSQbi/zyV6tpCFsE3UnM8UnHf0LepRspKzajckdN5sumj2aNxsA5Rw2hxvT+BtR3iqx8=
Message-ID: <4dfa50520703051335j34e7d92bl982705adcfd8b1d5@mail.gmail.com>
Date: Mon, 5 Mar 2007 13:35:20 -0800
From: "David Hubbard" <david.c.hubbard@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>, "Rudolf Marek" <r.marek@assembler.cz>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>, Ebbert <cebbert@redhat.com>,
       Chuck@atrpms.net, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Machek <pavel@ucw.cz>, Pavel@atrpms.net,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
In-Reply-To: <20070305221635.8b20eab5.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070228213803.GA4877@ucw.cz>
	 <20070302141840.GA3441@srcf.ucam.org>
	 <20070302220454.a0c66d04.khali@linux-fr.org>
	 <20070302211251.GA10035@srcf.ucam.org>
	 <20070303105316.d51e032d.khali@linux-fr.org>
	 <4dfa50520703030747g3c887f5bxe25caefd1723c635@mail.gmail.com>
	 <20070303155048.GA22755@srcf.ucam.org> <45E9AB8B.1070804@assembler.cz>
	 <45EB01E8.5080003@assembler.cz>
	 <20070305221635.8b20eab5.khali@linux-fr.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean, Rudolf,

> 1* It requires that we modify each driver individually. It's quite a
> shame that we have to update drivers all around the kernel tree with
> specific code to workaround a problem which is originally located in a
> single place (the ACPI subsystem.) That being said this isn't a blocker
> point, if this is the only way, we'll do it. But that's a rather great
> amount of work.

These additions to drivers might help with the kernel virtualization.

> 2* It seems to incur a signficant performance penalty.
> ____request_resource isn't cheap as far as I know. And in the
> absence of conflict, you are even allocating and releasing the resource
> on _each_ I/O operation, which certainly isn't cheap either. Again, it
> is not a blocker point, after all this is a workaround for an improper
> behavior of the acpi subsystem, this performance penalty is the price to
> pay. But there is also a performance penalty for legitimate I/O access,
> which worries me more.

I thought Rudolf's patch allocated the resource in the driver
(w83627ehf) and ACPI contacted the driver when it could not allocate
the resource. Since ACPI never *really* wants to allocate the
resource, is there a fast-path check it could do? This would help
performance.

> 3* What about concurrent accesses from ACPI itself? Unless we have a
> guarantee that only one kernel thread can run AML code at a given
> moment, I can imagine a conflict happening, as your code protects us
> well against ACPI and driver concurrent accesses, but not against two
> concurrent ACPI accesses. But I'm not familiar with ACPI - maybe we do
> have this guarantee? OTOH, if this ever happens, well, it would happen
> even without your code.

All of ACPI uses the same "virtualized" access mechanism, so even if
two threads are poking at the bank select register in a race condition
(that would be awful code, I think) they would see the same virtual
behavior.

> So for now I tend to think that the idea of a global AML lock proposed
> by Pavel Machek and Bodo Eggert would be more efficient. And it
> wouldn't need any driver-specific code, so it would be much more simple
> to implement. The drawback being that we serialize more than we really
> need to (e.g. the hardware monitoring driver will not be allowed to
> access the chip when _any_ AML code is running, not just when the AML
> code accesses the hardware monitoring chip, and if two drivers want to
> check the AML lock, they'll exclude each other as well.) But I wonder
> if this is a problem in practice. Maybe we'll have to make some
> profiling on both solutions and compare.

I like the virtualized driver method (if it wasn't obvious!) but the
global AML lock works also. It will be interesting to see profiling of
both solutions.

David
