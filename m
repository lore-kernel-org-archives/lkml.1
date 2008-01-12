Return-Path: <linux-kernel-owner+w=401wt.eu-S1763392AbYALNnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763392AbYALNnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 08:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYALNnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 08:43:05 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:52779 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbYALNnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 08:43:04 -0500
Message-ID: <4788C323.6090206@keyaccess.nl>
Date: Sat, 12 Jan 2008 14:39:47 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ondrej Zary <linux@rainbow-software.org>,
       Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andrew Morton <akpm@osdl.org>,
       Takashi Iwai <tiwai@suse.de>, linux-pm@lists.linux-foundation.org
Subject: Re: [alsa-devel] PNP_DRIVER_RES_DISABLE breaks swsusp at least with
 snd_cs4236
References: <200801092343.48726.linux@rainbow-software.org>	<20080111080141.75aaad5f@poseidon.drzeus.cx>	<47877B83.5040604@keyaccess.nl>	<200801111940.22023.linux@rainbow-software.org>	<4788168F.8070403@keyaccess.nl> <20080112121256.0f2e96ad@poseidon.drzeus.cx>
In-Reply-To: <20080112121256.0f2e96ad@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-01-08 12:12, Pierre Ossman wrote:

> On Sat, 12 Jan 2008 02:23:27 +0100
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> Pavel, Rafael -- the attached fixes snd-cs4236 not coming back to life for 
>> Ondrej after hibernation due to the PNP_DRIVER_RES_DO_NOT_CHANGE test 
>> triggering in pnp_bus_resume() and keeping the card in a suspended state.
>>
> 
> I'm a bit confused here. Bjorn Helgaas wanted to remove the pnp_start/stop_dev() calls completely, and you want them called all the time. :)

Wanted where? Haven't seen a coment from Bjorn? But -- while removing them 
both looks (as) sensible from a mirror-image viewpoint, this wouldn't fix 
the problem.

As fas as I understand things, "hibernation" is basically "save state, shut 
down machine" where the latter step is going to disable the card inevitably. 
On resume, you're going to need to restore the resources (that were saved in 
pnp_dev->res) that it was using to the card, which is what pnp_start_dev() 
does -- it not being called is the current problem of the card not coming 
back to life.

pnp_stop_dev() could go in this specific situation. Not much point in first 
disabling the thing it seems if a subsequent shutdown is going to take care 
of that anyway. However, suspend/resume isn't just called in the case of 
complete hibernation I guess and I know nothing about it all -- hence my 
request to the hiberhation people for how this is designed to be.

But we certainly need the pnp_start_dev() in the current flow of things. It 
not being called is the problem this fixes...

Rene.
