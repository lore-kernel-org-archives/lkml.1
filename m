Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbZIOXpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbZIOXpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 19:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZIOXpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 19:45:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5279 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZIOXpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 19:45:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jsUzFHnCqeBealWqbvW+Izq0hkMIQSZVCWI+StuByYWi6Zq6py4lgkgiiBl/Mc7km
	ahNsXm9eWTUbBbhHv64nA==
Date: Tue, 15 Sep 2009 16:45:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kurt Roeckx <kurt@roeckx.be>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Subject: Re: [Bug #13780] NULL pointer dereference loading powernowk8
In-Reply-To: <200909102259.15144.rjw@sisk.pl>
Message-ID: <alpine.DEB.1.00.0909151642100.24059@chino.kir.corp.google.com>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera> <200909080112.14997.rjw@sisk.pl> <20090908194653.GA3517@roeckx.be> <200909102259.15144.rjw@sisk.pl>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Sep 2009, Rafael J. Wysocki wrote:

> > So I did a biset, and this is the result:
> > $ git bisect good
> > 0e64a0c982c06a6b8f5e2a7f29eb108fdf257b2f is first bad commit
> > commit 0e64a0c982c06a6b8f5e2a7f29eb108fdf257b2f
> > Author: Dave Jones <davej@redhat.com>
> > Date:   Wed Feb 4 14:37:50 2009 -0500
> > 
> >     [CPUFREQ] checkpatch cleanups for powernow-k8
> > 
> >     This driver has so many long function names, and deep nested if's
> >     The remaining warnings will need some code restructuring to clean up.
> > 
> >     Signed-off-by: Dave Jones <davej@redhat.com>
> > 
> > :040000 040000 45d8e325663e62e0833cf4e1cb8b27fa4a9b3a56 affb6fab44cb22aca8a33ca0d767797831fc2bae M      arch
> > 
> > 2.6.29-rc5 is good, -rc7 is bad.
> 
> Thanks for the update and for doing the bisection.
> 

0e64a0c has this cleanup, which isn't equivalent to the previous code:

@@ -779,11 +834,12 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 		goto err_out;
 	}
 
-	if ((data->acpi_data.control_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE) ||
-		(data->acpi_data.status_register.space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
+	space_id = data->acpi_data.control_register.space_id;
+	if ((space_id != ACPI_ADR_SPACE_FIXED_HARDWARE) ||
+		(space_id != ACPI_ADR_SPACE_FIXED_HARDWARE)) {
 		dprintk("Invalid control/status registers (%x - %x)\n",
 			data->acpi_data.control_register.space_id,
-			data->acpi_data.status_register.space_id);
+			space_id);
 		goto err_out;
 	}
 
This got fixed in 2c701b1 in 2.6.31-rc8, so this is most likely the 
problem that Kurt was encountering.

Kurt, could you try 2.6.31 and see if you still experience the issue?  If 
not, this can be closed.
