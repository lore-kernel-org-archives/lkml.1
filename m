Return-Path: <linux-kernel-owner+w=401wt.eu-S1760104AbYBKTmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104AbYBKTmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbYBKTmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:42:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49994 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167AbYBKTmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:42:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47B0A50D.6060807@s5r6.in-berlin.de>
Date: Mon, 11 Feb 2008 20:42:05 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] firewire: fw-sbp2: don't add scsi_device twice
References: <tkrat.f34e34fd91a0695f@s5r6.in-berlin.de> <tkrat.2ef253adcedcb9ea@s5r6.in-berlin.de> <47B083A0.4090900@redhat.com>
In-Reply-To: <47B083A0.4090900@redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Stefan Richter wrote:
>> When a reconnect failed but re-login succeeded, __scsi_add_device was
>> called again.
>>
>> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> Was the spurious __scsi_add_device simply failing, or was it causing
> other problems as well? I can't remember if I've hit that or not. In
> either case, not calling it when we know we don't need to makes sense.

SCSI core looks up whether the scsi_target and the scsi_device already
exist.  If so, __scsi_add_device succeeds (there should also be a log
message "scsi scan: device exists on %s\n") and returns the pointer to
the existing scsi_device.

The code in fw-sbp2 before this patch series would then continue
appropriately ... except that it misses to call sbp2_cancel_orbs.  Right
now I am not quite sure which consequences that has; probably no serious
ones right now.  SCSI core would call fw-sbp2's eh_abort_handler
eventually which would reset the fetch agent once more and cancel the
timed out ORBs.  So, besides the needless lookups and temporary
allocations in SCSI core, we avoid the additional stall and timeout
until eh_abort_handler hits.

I shall add this to the changelog.

BTW, since the addition of the blocking and unblocking between bus reset
and reconnect/re-login we also need the unblocking call in the re-login
case but not (necessarily) in the first login case.
-- 
Stefan Richter
-=====-==--- --=- -=-==
http://arcgraph.de/sr/
