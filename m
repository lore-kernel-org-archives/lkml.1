Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbZKEPhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbZKEPhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 10:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZKEPhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 10:37:42 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:64112 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZKEPhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 10:37:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZONOOLxKx1P4bqHXBenEaAWfy50S5xL7yCXRJSzYQDbuScLtXAHo83SMhUhKa+2wvT
         ezluHaDjPajW0F+XsnWMP/UWwk8UhrRt6As/su99fNDlY3oJJYlhFIpG9R8RkxUqxnBq
         q961+GE6FhFqufvenyUVMq+62+e0EERhUrBsg=
Date: Thu, 5 Nov 2009 16:37:42 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: dimm <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode
 output messages
Message-ID: <20091105153742.GA18592@alberich.amd.com>
References: <1257192496.5941.8.camel@dimm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257192496.5941.8.camel@dimm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches don't properly work here.

(1) For instance I got following log entries when doing
    suspend/resume, doing CPU offline/online test and reloading the
    module:

  microcode: original microcode versions...
  microcode: CPU0-3: patch_level=0x1000065


  platform microcode: firmware: requesting amd-ucode/microcode_amd.bin
  ...
  microcode: CPU0-1,3: patch_level=0x1000083

  microcode: CPU2-3: patch_level=0x1000065

  Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba

The patch levels are:

  # for i in `seq 0 3`; do lsmsr -c $i PATCH_LEVEL; done
  PATCH_LEVEL          = 0x0000000001000083
  PATCH_LEVEL          = 0x0000000001000083
  PATCH_LEVEL          = 0x0000000001000065
  PATCH_LEVEL          = 0x0000000001000065

(2) During suspend/resume the ucode is not updated:

  hadburg linux # for i in `seq 0 3`; do lsmsr -c $i PATCH_LEVEL; done
  PATCH_LEVEL          = 0x0000000001000083
  PATCH_LEVEL          = 0x0000000001000083
  PATCH_LEVEL          = 0x0000000001000083
  PATCH_LEVEL          = 0x0000000001000083
  hadburg linux # pm-suspend
  hadburg linux # for i in `seq 0 3`; do lsmsr -c $i PATCH_LEVEL; done
  PATCH_LEVEL          = 0x0000000001000065
  PATCH_LEVEL          = 0x0000000001000065
  PATCH_LEVEL          = 0x0000000001000065
  PATCH_LEVEL          = 0x0000000001000065


That used to work w/o your patches. Didn't have time to look why this
is now failing. You've changed mc_cpu_callback() -- most likely that
is causing this regression.


Regards,
Andreas
