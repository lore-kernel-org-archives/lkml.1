Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbXLFPsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbXLFPsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXLFPsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:48:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62880 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXLFPso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:48:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
Date: Thu, 6 Dec 2007 16:48:23 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Joachim Fenkes <fenkes@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>
References: <200712061607.20004.fenkes@de.ibm.com>
In-Reply-To: <200712061607.20004.fenkes@de.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712061648.24806.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18ECsWX/ARZM+R9vX7FtTwellb5CxutnzAnzNs
 +veew3yh41sPWeTkc5Y/S2n1G4Fj+gJjtT1J7GkyZ1J8M4bgWV
 y+7YEJslrx+vPk1j034LQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007, Joachim Fenkes wrote:
>         printk(KERN_INFO "eHCA Infiniband Device Driver "
>                "(Version " HCAD_VERSION ")\n");
>  
> +       /* Autodetect hCall locking -- we can't read the firmware version
> +        * directly, but we know that starting with POWER6, all firmware
> +        * versions are good.
> +        */
> +       if (ehca_lock_hcalls == -1)
> +               ehca_lock_hcalls = !(cur_cpu_spec->cpu_user_features
> +                                    & PPC_FEATURE_ARCH_2_05);
> +
>         ret = ehca_create_comp_pool();
>         if (ret) {
>                 ehca_gen_err("Cannot create comp pool.");

We already talked about this yesterday, but I still feel that checking the
instruction set of the CPU should not be used to determine whether a
specific device driver implementation is used int hypervisor.

At the very least, I think you should change this to read the hypervisor
version number from the device tree, though the ideal solution would be
to have the absence of this bug encoded in the device node for the ehca
device itself.

Regarding the performance problem, have you checked whether converting all
your spin_lock_irqsave to spin_lock/spin_lock_irq improves your performance
on the older machines? Maybe it's already fast enough that way.

	Arnd <><
