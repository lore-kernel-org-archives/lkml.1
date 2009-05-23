Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZEWPTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZEWPTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 11:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZEWPTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 11:19:32 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:33687 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZEWPTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 11:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=CQPKrhCLNjIR/avm67A0plQ91gftTmdjidE9Ci6wNKCKfaff13EYX2NcpSlpO1/3fV
         msdV+l9WBY19Sujy8RbljXn8w+4ZA6lvs6isv9WosgcF9RTj3/sd7zpcCqgHEMkk+8sj
         CtYiTvNFunr/NuM5Y4z8NhyR2X7JUX3TycdQE=
MIME-Version: 1.0
From: Jan Kucera <kucera.jan.cz@gmail.com>
Date: Sat, 23 May 2009 17:19:12 +0200
X-Google-Sender-Auth: 822063b3297ef009
Message-ID: <ef67228d0905230819x633f0cd0t4dd1be639906f9bc@mail.gmail.com>
Subject: Possible deadlock in jfs_imap.c?
To: jfs-discussion@lists.sourceforge.net
Cc: shaggy@austin.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

for my master thesis, I've designed static checker for finding deadlocks in C.
My tool found some possible deadlock in file fs/jfs/jfs_imap.c
between JFS_IP(ipimap)->commit_mutex and  imap->im_aglock[agno].

Reason of this problem is probably missed unlocking of
JFS_IP(ipimap)->commit_mutex in branch starting at line 2564 which
leaves JFS_IP(ipimap)->commit_mutex locked:

    in function diNewIAG(..)
        locking mutex_lock(&JFS_IP(ipimap)->commit_mutex) at line 2540
        condition at line 2543 is false
        condition at line 2564 is true
        goto out: at 2579
        IAGFREE_UNLOCK(imap); at line 2654
    return from diNewIAG(..) at line 2656

Version of kernel is 2.6.28 (maybe this code is in newer versions too).
Could someone confirm, that this is a real bug? Thank you for your time.
