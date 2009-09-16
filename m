Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZIPCTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZIPCTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 22:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbZIPCTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 22:19:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:51164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZIPCTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 22:19:43 -0400
Message-ID: <4AB04B39.7030907@kernel.org>
Date: Wed, 16 Sep 2009 11:19:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.31-rc5 regression: hd don't show up
References: <h63737$b2a$1@ger.gmane.org> <4A852BC0.1090404@kernel.org> <4A8559D7.6090405@klingt.org> <4A8774E5.4070609@kernel.org> <4A87D9FC.9070408@klingt.org> <4A96460F.3020600@kernel.org> <4A965E3B.3000808@klingt.org> <4A966F7D.60707@kernel.org> <4A97B9C0.9090003@klingt.org> <4A9B7E1E.8060909@kernel.org> <4A9DAF78.4070703@klingt.org> <4A9DD6D9.50407@kernel.org> <4A9E371A.5040208@klingt.org> <4A9FCD8C.6010107@kernel.org> <4AA18F57.8030107@klingt.org> <4AA1ACF8.7030101@kernel.org> <4AA6C569.9090901@klingt.org>
In-Reply-To: <4AA6C569.9090901@klingt.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 02:19:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Tim Blechmann wrote:
> with this patch, i could reproduce it again on the first boot. bootlog
> attached.

Thanks a lot for testing.  The offending commit is 816ab897.

commit 816ab89782ac139a8b65147cca990822bb7e8675
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Oct 22 00:31:34 2008 +0900

    libata: set device class to NONE if phys_offline

    Reset methods don't have access to phys link status for slave links
    and may incorrectly indicate device presence causing unnecessary probe
    failures for unoccupied links.  This patch clears device class to NONE
    during post-reset processing if phys link is offline.

    As on/offlineness semantics is strictly defined and used in multiple
    places by the core layer, this won't change behavior for drivers which
    don't use slave links.

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

The problem is that I don't really remember why I added this one back
then.  This is incorrect because the condition should be dealt with
later in the reset logic.  That didn't work quite as expected and I
ended up adding the above to work around that and it turned out wrong.
I'll dig deeper and find out what was the problem back then.

Thanks.

-- 
tejun
