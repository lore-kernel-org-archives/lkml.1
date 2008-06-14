Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbYFNRry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbYFNRry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 13:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbYFNRrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 13:47:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:9214 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbYFNRrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 13:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=IvAMPjlayV4s6+R/Z/jYo35Lh992/a/gRlhNGBpgHFWUtgmaq30KdoUgFvHpQ4MoCv
         tdVu0xPo+2Cb1c74j9u4EP6/xHwe15maOBRy0BJF43H4MEqNz9oZ7aJp8Syl6U4qUzvp
         kyBEIZ9v5rxRcBI5bd1R5LWxldrG2tSCwwT/A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 03/18] ide-cd: cdrom_decode_status: factor out block pc error handling code
Date: Sat, 14 Jun 2008 19:29:21 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com> <1213252870-20474-4-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1213252870-20474-4-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806141929.21329.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008, Borislav Petkov wrote:
> ... into cdrom_handle_failed_pc_req().

I actually think that we should try to unite pc/fs error handling as much
as possible as it shouldn't really matter if i.e. READ command came through
fs or pc request - the error handling w.r.t. hardware should be the same
(at the moment it is not always the case - the most blatant example of this
disrepancy is handling of NOT_READY sense key for WRITE commands).

When I was suggesting factoring out error handling I rather meant moving
out _everything_ after OK_STAT() (sorry for the confusion).  On the second
thought we may do it in even simpler way by moving:

...
	/* check for errors */
	stat = ide_read_status(drive);

	if (stat_ret)
		*stat_ret = stat;

	if (OK_STAT(stat, good_stat, BAD_R_STAT))
		return 0;
...

to cdrom_decode_status() users and passing as an argument 'stat' instead
of 'good_stat' and 'stat_ret'.

Therefore I skipped this patch (and also patch #4) for now.
