Return-Path: <linux-kernel-owner+w=401wt.eu-S1423216AbXBHL3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423216AbXBHL3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 06:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423231AbXBHL3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 06:29:36 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:19799 "EHLO
	outbound2-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423216AbXBHL3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 06:29:35 -0500
X-BigFish: V
Subject: Re: [LIBATA BUG] sr.c: TEST_UNIT_READY error
From: Conke Hu <conke.hu@amd.com>
Reply-To: conke.hu@amd.com
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45C9C8BF.6030501@garzik.org>
References: <1170101430.29240.34.camel@localhost.localdomain>
	 <20070129133849.1b523226@freekitty>
	 <1170109401.29240.49.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
	 <20070129144055.151cfe52@freekitty> <Pine  <45C9C8BF.6030501@garzik.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: AMD
Date: Fri, 02 Feb 2007 13:48:06 +0800
Message-Id: <1170395286.4626.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-OriginalArrivalTime: 08 Feb 2007 11:28:50.0606 (UTC) FILETIME=[4E587CE0:01C74B74]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 07:40 -0500, Jeff Garzik wrote:
> Conke Hu wrote:
> > Hi,
> >    TEST_UNIT_READY in get_capabilities (drivers/scsi/sr.c line 743, or
> > see below) always returns error.
> > 
> >   ---------------- code begin -----------------------------
> >     retries = 0;
> >     do {
> >         memset((void *)cmd, 0, MAX_COMMAND_SIZE);
> >         cmd[0] = TEST_UNIT_READY;
> > 
> >         the_result = scsi_execute_req (cd->device, cmd, DMA_NONE, NULL,
> >                            0, &sshdr, SR_TIMEOUT,
> >                            MAX_RETRIES);
> > 
> >         retries++;
> >     } while (retries < 5 &&
> >          (!scsi_status_is_good(the_result) ||
> >           (scsi_sense_valid(&sshdr) &&
> >            sshdr.sense_key == UNIT_ATTENTION)));
> >   ---------------- code end -----------------------------
> > 
> >   I debugged all kernel versions from 2.6.17 to 2.6.20 on several AMD
> > and other vendor's PATA/IDE controllers, and I get the_result==0x8000002
> > and retries==5; on silicon image 3132, i get the_result=0x2eb.
> >   Does 0x8000002 mean ((DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION)?
> > what's wrong?
> 
> What does the sense data returned in the sense buffer say is wrong?
> 
> 	Jeff

I dump scsi_sense_hdr as follows:
sshdr.response_code = 0x70
sshdr.sense_key = 0x2
sshdr.asc = 0x3a
sshdr.ascq = 0x1
sshdr.additional_length = 0x0

the sense_key is 0x2 (NOT_READY), but the expected UNIT_ATTENTION :(

BTW, I am sorry for a mistake, Sil3132 also returns 0x8000002, not 0x2eb
as I said in the first mail. In a word, all cases return "the_result" as
0x8000002.

Conke



