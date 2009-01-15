Return-Path: <linux-kernel-owner+w=401wt.eu-S1756712AbZAOBWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712AbZAOBWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 20:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZAOBWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 20:22:41 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:36880 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZAOBWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 20:22:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EacyEoRzbw7P2Vxyk6Enifbx65IkY4NwKpmDKEd3cq53USQfq9WHT51XHnsrO5V0Ka
         uCZ6CL1SOy5HNCNzJ9rTjKL04ZivZ1gWa0lRp3lDA1t/YCoWDfF3EV3KbglWA2gzDH//
         r4LZgT3BOMXMPgpzlNczHHfBgVrbAwf1/gdcE=
Message-ID: <9f4f8abe0901141722x40bbe5b5lcdd8f10463517c14@mail.gmail.com>
Date: Wed, 14 Jan 2009 17:22:39 -0800
From: "Vineet Gupta" <vineetg76@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: dma_sync_api usage in drivers/ieee1394/sbp2.c
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While implementing dma map/sync APIs for a non-coherent DMA arch I ran
into a use-case in IEEE1394 driver.

1. In sbp2util_create_command_orb_pool( ),  dma_map_single(TO_DEVICE)
is called for cmd->command_orb. Since this is ownership handover to
driver, dcache wback #1 done for arch such as ARM]

2. In sbp2_create_command_orb ( ), it's ownership is transferred back
to CPU so that driver can mod it by calling dma_sync_single_for_cpu (
TO_DEVICE ), [ this causes dcache wback #2]

3. at the end of same function, when finally driver is done with
creating the cmd, it calls dma_sync_single_for_device (TO_DEVICE) [
dcache wback #3]

So dcache lines were flushed for the buffer 3 times whereas it was
really required only once (maybe it was ok to do it at the time of map
, but certainly for every sbp2_create_command_orb( ) it can be done
only once instead of twice).

This is happening because ownership handover is being explicitly
specified using _cpu( )  and _device( ) which has the upside that it
makes the code really readable but the downside being it is not really
efficient

As an optimization can sync_for_cpu (TO_DEVICE) be implemented as nop
because that would REALLY mean cpu wants to own it. Similarly
corollary case, sync_for_device (FROM_DEVICE) can be made a nop.

Do other people think the same too or am I missing something really
fundamental here...

Thanks,
Vineet
