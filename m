Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXEJGgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXEJGgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbXEJGgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:36:38 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:49557 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbXEJGgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:36:36 -0400
Subject: Re: [PATCH] Cleanup libata HPA support
From: Ben Collins <ben.collins@ubuntu.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <464258C9.7040405@shaw.ca>
References: <fa.7iNoP7Qs8RAGjCdw2nQZBKOCxZU@ifi.uio.no>
	 <46408D43.3020300@shaw.ca> <1178692170.6962.146.camel@cunning>
	 <464258C9.7040405@shaw.ca>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 10 May 2007 08:36:32 +0200
Message-Id: <1178778992.5910.24.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 17:27 -0600, Robert Hancock wrote:
> Ben Collins wrote:
> > On Tue, 2007-05-08 at 08:46 -0600, Robert Hancock wrote:
> >> Ben Collins wrote:
> >>> The original HPA patch that Kyle worked on has gone into current git
> >>> without some fixes that we worked through late in the Ubuntu feisty
> >>> release. Here's the main copy of the notes I sent to Alan a few weeks
> >>> ago in regards to the original patch, and a repatch against current git
> >>> to fix things up. Note we have released feisty with the patch attached
> >>> (albeit we have HPA enabled by default), and we have not had any reports
> >>> directly attributed to it. However, in gutsy (devel for next release,
> >>> based on current stock linux-2.6.git), we are already seeing reports of
> >>> the same issues we already fixed. 
> >>>
> >>> The issues we saw were mainly that some controllers didn't return the
> >>> correct size from the SET_MAX command (sata_nv is a good example). So I
> >>> added a re IDENTIFY after the SET_MAX, and compared all the numbers. If
> >>> re-id was correct, but return value from SET_MAX wasn't we print a
> >>> warning and use the IDENTIFY value regardless (since that's what the
> >>> device is going to use).
> >>>
> >>> Because we re IDENTIFY, there was also no need to keep n_sectors_boot
> >>> around, so that was removed. The ata_hpa_resize() was changed to handle
> >>> everything in a single call (checks for HPA support of the device, and
> >>> whether ignore_hpa is set or not), and it also sets dev->n_sectors
> >>> before returning.
> >>>
> >>> So far with this patch, we were able to fix all the problems we were
> >>> seeing with it (except the sata_nv issue where we had to revert to not
> >>> using adma for NO_DATA transactions, already reported to libata-dev).
> >>> We've not had any reports of further problems.
> >> That sata_nv issue should not be present anymore in the current 
> >> libata-dev tree.
> > 
> > That's correct, it is not, at least the machine exception problem isn't.
> > However, the incorrect returns from SET_MAX are still an issue with that
> > hw. No idea what is causing it.
> 
> Curious.. Do you have some output or other details from what was 
> actually returned? Also was this on more than one drive model?

I no longer have these outputs handy, although a bug report on
launchpad.net might have it (linux-source-2.6.20 package).

It was an abnormally huge value (hence the exposed signed extension
problems I fixed). The incorrect value was always the same for the same
controller/drive pair. It was not specific to a drive model, only
sata_nv (and I think pata_amd) was common to these cases.

Due to the extreme proximity of this bug being exposed to our release
deadline, we did not investigate the absolute cause of the issue, just
implemented a safer HPA detection to avoid them. If you have a sata_nv,
it is easy to get these values even with my patch since it outputs a
warning with the incorrect read back from SET_MAX. So the problems wont
go unnoticed.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

