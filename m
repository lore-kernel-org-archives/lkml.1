Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbYGPV0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbYGPV0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbYGPV03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:26:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58833 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbYGPV02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:26:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Date: Wed, 16 Jul 2008 23:28:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
References: <1216077806.27455.85.camel@shinybook.infradead.org> <1216154956.26991.30.camel@shinybook.infradead.org> <1216191718.30898.16.camel@shinybook.infradead.org>
In-Reply-To: <1216191718.30898.16.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807162328.37754.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 16 of July 2008, David Woodhouse wrote:
> On Tue, 2008-07-15 at 13:49 -0700, David Woodhouse wrote:
> > I need to hassle Sam about that.
> 
> I think I have it. Rafael, does _this_ fix it for you?

No, but the error message seems to be different:

  HOSTCC  firmware/ihex2fw
/home/rafael/src/linux-next/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system
compilation terminated.

Removing the FORCE from line 117 of scripts/Makefile.host makes it work.

Of course, I still have to run "make ... firmware_install" locally on the
server.

> diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
> index 3d2f460..994060d 100644
> --- a/scripts/Makefile.fwinst
> +++ b/scripts/Makefile.fwinst
> @@ -43,3 +43,15 @@ __fw_install: $(installed-fw)
>  __fw_modinst: $(mod-fw)
>  
>  FORCE:
> +
> +# Read all saved command lines and dependencies for the $(targets) we
> +# may be building using $(if_changed{,_dep}). As an optimization, we 
> +# don't need to read them if the target does not exist; we will rebuild
> +# anyway in that case.
> +
> +targets := $(wildcard $(sort $(targets)))
> +cmd_files := $(wildcard $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))
> +
> +ifneq ($(cmd_files),)
> +  include $(cmd_files)
> +endif
> 


