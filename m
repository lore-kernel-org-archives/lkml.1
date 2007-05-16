Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXEPJP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXEPJP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 05:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbXEPJPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 05:15:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:58283 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXEPJPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 05:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LZHzqa4iYqaFBpKWnGvDhAm89Owp6esDT4X5gBaXelmfg55R7QWQ7VPHFCRrOpBohHCeqMyliXAAlQYyCqE6MVUrZrO7bgUbezpvUIa79fUUf3lhvPZIhfOXvNeFcr4RwMtILMyPH4KGnX2ib4HeCqagCIZEB+IppwEr2lifQLo=
Message-ID: <e5ab0f710705160215p6b11bffeh53796b1b2223fd6d@mail.gmail.com>
Date: Wed, 16 May 2007 11:15:49 +0200
From: "Francesco Pretto" <ceztko@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
Cc: "Dave Jones" <davej@redhat.com>, "Tejun Heo" <htejun@gmail.com>,
       "Phillip Susi" <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200705160129.16048.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>
	 <46489D3B.8050805@gmail.com> <20070515210804.GG25902@redhat.com>
	 <200705160129.16048.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/5/16, Rob Landley <rob@landley.net>:
> (Is there any other piece of hardware that needs userspace to quiesce it just
> so the _off_switch_ can take effect?  Yes, I read both the gmane thread and
> the linux-ata.org link.  I used to maintain the busybox halt/reboot/poweroff
> commands, although I don't anymore.  That just called reboot(), and this
> worked.)
>

For what i understood, there were a misunderstanding caused by the
wrong assumption that shutdown(8) implementations were issuing
STANDBYNOW on all hard disk devices on the system (indistinctly from
the interface, old-ide/libata/scsi). The fact is that sysvinit and
others actually do something with the old interface /proc/ide, trying
to spindown the hard disks. This worked only on systems using the old
ide/ata drivers because kernel prior to 2.6.22rc1 didn't even have the
necessary feature to spindown hard disks using the libata or the scsi
interface.

Hopefully, with the patch in discussion, there will be an happy ending with:

- sysvinit and derived implementations:
if ( old ide/ata drivers are used )
  {continue to do the old userland spindown mechanism with /proc/ide; }
// else
//  { do nothing; }
reboot();

- everyone else:
// continue to do nothing :-)
reboot();

If exists some, at this point, exotic shutdown(8) implementation that
is trying to issue STANDBYBOW on libata/scsi devices, it will get a
fat warning. The warning could also state that the only supported way
is to leave complete responsibility of spinning down the hard disks to
kernel, so eventually it could be cleaned of checks and compatibility
options.

[1] http://article.gmane.org/gmane.linux.ide/18846
