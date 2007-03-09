Return-Path: <linux-kernel-owner+w=401wt.eu-S965784AbXCIMWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965784AbXCIMWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965783AbXCIMWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:22:03 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:11313 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965781AbXCIMWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:22:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X8BdVGtikJXZxNsFYZcQT1DeKRhQzaNa+vxO/b7CcYGxbgsLCQH8TE+VfexWOL5os1v8885Z3YJo7+gqrVnMm0eVpfJ89cLWX3+kDSG1PPUUtPPQWKjWvX/VMKE8ZpuTYI0++Uiss824Nd/RQeY1y5h/PEc/rL33HcEpHJO9SLA=
Message-ID: <5767b9100703090421h27711ceeqda5648eefd428456@mail.gmail.com>
Date: Fri, 9 Mar 2007 20:21:57 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [BUG] ATAPI command TEST_UNIT_READY never succeeds!
Cc: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <45EEAFB4.3060306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5767b9100703070409o3e094420rf7ccffc436332184@mail.gmail.com>
	 <5767b9100703070423y194bf492wad28ddc66ab98775@mail.gmail.com>
	 <45EEAFB4.3060306@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Tejun Heo <htejun@gmail.com> wrote:
> (snip)
> I've read your last posting about this, but forgot to follow up.  TUR is
> supposed to fail if ATAPI device doesn't have media loaded.  TUR fails
> and sense data returns device not ready - media not present.  That's the
> normal operation.  Does TUR fail even with media loaded or is sense data
> not properly fetched?
>

Thank you, Tejun! I did forget to load any media :(
When I load media and retry, TUR succeeds but there is still a
problem: when using ahci driver, TUR will not succeed unless it runs
twice, and the following loop always runs till retries==2
-------------------- code in sr.c, get_capabilities() -------------------------
	retries = 0;
	do {
		memset((void *)cmd, 0, MAX_COMMAND_SIZE);
		cmd[0] = TEST_UNIT_READY;

		the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
					       0, &sshdr, SR_TIMEOUT,
					       MAX_RETRIES);

		retries++;
	} while (retries < 5 &&
		 (!scsi_status_is_good(the_result) ||
		  (scsi_sense_valid(&sshdr) &&
		   sshdr.sense_key == UNIT_ATTENTION)));
------------------------------------- end code
-------------------------------------

this issue only occurs in ahci driver,  and libata + pata driver is OK.

Conke
