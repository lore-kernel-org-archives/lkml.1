Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYC2Rqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYC2Rqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 13:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYC2RqC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 13:46:02 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:24309 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYC2Rp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 13:45:59 -0400
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 0/5] ide-tape: refit tape data buffer bits/kill pipelining
Date: Sat, 29 Mar 2008 18:46:04 +0100
Message-Id: <1206812769-10065-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

This patchset refits the tape->merge_stage pipeline stage into tape->bh, a
singly linked list of idetape_bh's, each of which is a tag attached to one or
more pages serving as a buffer for data requests. The original functionality
is kept wrt collecting data in the buffer and flushing it to the hardware
when full.

Currently, the data rq's are serialized on the block interface and it
would probably be better to return immediately after issuing it over
ide_do_drive_cmd() in order to increase throughput, proper locking and testing
implied of course.

 drivers/ide/ide-tape.c |  393 +++++++++++++++++-------------------------------
 1 files changed, 135 insertions(+), 258 deletions(-)
