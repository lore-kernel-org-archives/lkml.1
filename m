Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbZGGVu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbZGGVu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbZGGVuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:50:52 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:46533 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754976AbZGGVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:50:51 -0400
Subject: Re: Possible memory leak in request_firmware()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ming Lei <tom.leiming@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090707190125.61920d00@gondolin>
References: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
	 <20090707190125.61920d00@gondolin>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 07 Jul 2009 22:50:45 +0100
Message-Id: <1247003445.5710.7.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 21:50:46.0975 (UTC) FILETIME=[FC2684F0:01C9FF4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 19:01 +0200, Cornelia Huck wrote:
> On Tue, 07 Jul 2009 16:17:00 +0100,
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > The patch below may fix the problem but it's only later tonight that I
> > can test it and confirm:
> 
> Your patch looks fine to me (didn't test it either), just one minor nit:

I tested it and it solves this leak.

> > @@ -407,14 +407,13 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
> >  	retval = device_register(f_dev);
> >  	if (retval) {
> >  		dev_err(device, "%s: device_register failed\n", __func__);
> > +		kfree(fw_priv->fw_id);
> 
> fw_priv->fw_id will be freed in the release function, so you don't need
> to free it here.

OK, thanks.

There is one more leak in this area which I couldn't figure out where it
should be freed:

unreferenced object 0xc353e530 (size 512):
  comm "cat", pid 3130, jiffies 4294903232
  backtrace:
    [<c01e6f6a>] create_object+0xfa/0x250
    [<c01e753d>] kmemleak_alloc+0x5d/0x70
    [<c01e223d>] __kmalloc+0x10d/0x210
    [<c03b2d2f>] firmware_data_write+0x1df/0x270
    [<c024163a>] write+0x13a/0x1b0
    [<c01eae1c>] vfs_write+0x9c/0x190
    [<c01eafcd>] sys_write+0x3d/0x70
    [<c010319c>] sysenter_do_call+0x12/0x38
    [<ffffffff>] 0xffffffff

Any idea? It looks like this is the kmalloc() in fw_realloc_buffer()
(inlined in firmware_data_write).

-- 
Catalin

