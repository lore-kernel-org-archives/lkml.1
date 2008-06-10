Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYFJXB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYFJXB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYFJXBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:01:49 -0400
Received: from mail2.briontech.com ([66.166.78.5]:40093 "EHLO
	mail2.briontech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYFJXBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:01:48 -0400
X-Greylist: delayed 1999 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2008 19:01:48 EDT
From: Luoqi Chen <Luoqi.Chen@brion.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Jun 2008 15:05:11 -0700
Subject: NFS open/setuid/ftruncate problem
Thread-Topic: NFS open/setuid/ftruncate problem
Thread-Index: AcjLRg1M2ssHd19jRuq1zZLIPt3sEw==
Message-ID: <0707E37B6D2E244C85660487B602C9221D9D9846@ex02.briontech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 10 Jun 2008 22:05:13.0342 (UTC) FILETIME=[0E9DA1E0:01C8CB46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've recently encountered a problem which could be a bug in the nfs implementation.
It could be illustrated with the following small program,

#include <fcntl.h>
#include <unistd.h>

main()
{
        int fd;

        fd = open("abc", O_WRONLY | O_CREAT, 0644);
        if (fd < 0) {
                perror("open");
                exit(-1);
        }

        write(fd, "test\n", 5);

        setuid(65534);

        if (ftruncate(fd, 3) < 0)
                perror("ftruncate");

        close(fd);
}

Compile and run it as root on an NFS mount without root squash, ftruncate() would
return an EACCESS error. On a local disk, it would complete successfully, leaving
behind a file "abc" with the string "tes". It would also be successful on NFS
if you change the mode from 0644 to 0666 (make sure to set your umask to 0).

I'm not familiar with linux nfs code, but it seems to me that the nfs code does
an additional access mode check in ftruncate/setattr, which is not done on a local
fs. I've checked on freebsd, the program works fine on both local and nfs.

Could someone more familiar with the nfs code take a look? I'm running 2.6.9-42.Elsmp
64-bit, nfsv3 mount. For nfs server, I've tried linux/freebsd and a commercial one
with a proprietary OS.

Thanks
-luoqi

PS: I'm not a subscriber of the linux kernel mailing list, I'd appreciate if any
response could be send to me directly.
