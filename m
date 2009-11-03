Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZKCRPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZKCRPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZKCRPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:15:47 -0500
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:53838 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752267AbZKCRPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:15:47 -0500
Date: Tue, 3 Nov 2009 10:15:38 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com
Subject: Re: [PATCH] TPM: Let the tpm char device be openable multiple times
Message-ID: <20091103171538.GP1966@obsidianresearch.com>
References: <20091103003511.GL7768@obsidianresearch.com> <20091103104352.3a460ae9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103104352.3a460ae9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 10:43:52AM +0000, Alan Cox wrote:
> > - Move the user space data buffer and related goop into a
> >   struct tpm_file, create one struct tpm_file per open file.
> 
> Is that really sufficient ?

Yes, I think so. Basically, all I did was take the per-device locking
that was already there and make it per-file. The locking hasn't
changed. If there was a multi-threading bug in the old code, it is
still in this version - but I looked for such a thing and didn't
see anything.

> You can open a file once, dup it (or inherit it and get multiple callers
> from the same file handle. Ditto consider threated apps

Yes, I did, I think it is OK. All the operations involving the file's
buffer are atomic or protected by a per-file mutex. Do you see
something specific?

It would be dangerous to do that anyhow, the way the TPM interface
works requires matched write/read pairs. The driver has a hacky way to
halt a write until the matching write happens, but it is based on
timeouts and probably isn't 100% reliable.

Thanks,
Jason
