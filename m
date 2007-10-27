Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbXJ0AC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbXJ0AC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 20:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXJ0ACT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 20:02:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:24222 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbXJ0ACT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 20:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VAivX0bFlgj5oUStNDB0fE0Znn+5WOabR7wyJSwEGCrr+h8aHMC+qfXfy0x7QHPkIwpH1JgfpGhkrcamFcM8A5W3MjnqhLcx4i8PpXcQjZAaGUgiGliO9WlHS+XhXcQwezR+4bOnMJVtBiK666u2nUq41KhApK//9tDgMjpsHBs=
Message-ID: <524f69650710261702u5ff24c25qa2597dca70df24f0@mail.gmail.com>
Date: Fri, 26 Oct 2007 19:02:17 -0500
From: "Steve French" <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: "CIFS VFS: server not responding" with some client/server combinations
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> often I get "CIFS VFS: server not responding".
> together with "CIFS VFS: No response for cmd 50 mid xxx" The xxx number
> seems to vary.   The problem seems to be triggered by any operation
> which touches lots of  files quickly. E.g.
> by copying source file directories onto or from it or simply by find.
>
> Copying single larger files (I generated a 100MB file with dd) don't seems
> to hurt.
>
> Interestinly -- this is where the really strange part comes -- it seems to
> work on the client which has debian Etch

There are a couple of common ways to attack this kind of problem,
to identify if the server is hanging up or the client or network stack is
losing the response.    There were some (now fixed) bugs in
cifs_demultiplex_thread (whose frequency should have been very rare, but
seemed to be more common on some distros) which could cause
responses to be discarded by the client.

I typically would run a wireshark trace so I could look at whether the
server really did respond (you can look at the mid to correlate the
trace with the dmesg log warning).  There is another way to see
if the server is getting slow (but not so slow that the client
is giving up) - by turning on CONFIG_CIFS_STATS2 (CIFS "Extended Statistics"
in menuconfig) in which case "slow" (longer than 1 second) responses are
logged.   This can show problems with the server response long before we
reach the catastrophic more than 20 second delays you may be seeing.

You may want to build the current cifs backport of the most recent
fixes for cifs.ko (source at
http://pserver.samba.org/samba/ftp/cifs-cvs/cifs-1.50c.tar.gz) to see
if the problem is problem was on the client and is already fixed.
There is one additional EAGAIN handling problem in cifs_demultiplex
which is in mainline but not in the cifs backport yet which will be in
cifs 1.51 (which should be out later in the month).


-- 
Thanks,

Steve
