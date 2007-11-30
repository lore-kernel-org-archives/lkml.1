Return-Path: <linux-kernel-owner+w=401wt.eu-S935651AbXK3RNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935651AbXK3RNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762295AbXK3RMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:12:55 -0500
Received: from alto.filmlight.ltd.uk ([217.40.27.25]:34941 "HELO
	a.mx.filmlight.ltd.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758436AbXK3RMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:12:54 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 12:12:51 EST
Message-ID: <475042FB.8020106@filmlight.ltd.uk>
Date: Fri, 30 Nov 2007 17:06:03 +0000
From: Roger Willcocks <roger@filmlight.ltd.uk>
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: nfsd bug: create file with specific uid/gid
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nfsd/vfs.c:nfsd_create (the v2 version of create) says:

"Set file attributes. Mode has already been set and
setting uid/gid works only for root"

but it doesn't actually test for root-ness (which could happen if the 
access is no-root-squash). There's similar code without the comment in 
nfsd_create_v3. In both cases the test:

    if ((iap->ia_valid &= ~(ATTR_UID|ATTR_GID|ATTR_MODE)) != 0)

should read:

    if (current->fsuid != 0)
        iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
    if ((iap->ia_valid &= ~ATTR_MODE) != 0)

although arguably they should return an EPERM error if the uid/gid bits 
are set, instead of silently ignoring them.

--
Roger


