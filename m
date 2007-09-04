Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbXIDEEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbXIDEEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 00:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXIDEEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 00:04:43 -0400
Received: from mail153.messagelabs.com ([216.82.253.51]:43269 "HELO
	mail153.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750706AbXIDEEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 00:04:42 -0400
X-VirusChecked: Checked
X-Env-Sender: Mano.Pallewatta@motorola.com
X-Msg-Ref: server-5.tower-153.messagelabs.com!1188878680!4367772!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [129.188.136.8]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] linux-2.6.16.51 gzipped core dump patch
Date: Tue, 4 Sep 2007 00:04:37 -0400
Message-ID: <1188AA083E6C7C4EBCE34803004A84014FE932@de01exm72.ds.mot.com>
In-Reply-To: <20070904032637.GY21089@ftp.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] linux-2.6.16.51 gzipped core dump patch
Thread-Index: Acfuo2nlWM11V3gXRuGkPSdGaMtu9gABBqug
References: <1188AA083E6C7C4EBCE34803004A84014FE921@de01exm72.ds.mot.com> <20070904013811.GX21089@ftp.linux.org.uk> <1188AA083E6C7C4EBCE34803004A84014FE926@de01exm72.ds.mot.com> <20070904032637.GY21089@ftp.linux.org.uk>
From: "Pallewatta Mano-FPCD67" <Mano.Pallewatta@motorola.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This support was there in the 2.6.16.51 kernel. In fact there was no
call_usermodehelper_pipe().

Mano

-----Original Message-----
From: Al Viro [mailto:viro@ftp.linux.org.uk] 
Sent: Monday, September 03, 2007 8:27 PM
To: Pallewatta Mano-FPCD67
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux-2.6.16.51 gzipped core dump patch

On Mon, Sep 03, 2007 at 10:32:00PM -0400, Pallewatta Mano-FPCD67 wrote:
> This patch was developed for embedded systems which had limited space
> for file storage. If an external process is to compress core files you
> will need to store those files somewhere first as core dump output
> cannot be directly fed to the stdin of compression program.

Why?  Create a pipe, start a new process, put the reader struct file
into its descriptor table as stdin, do execve in new process and
pass the writer struct file to ->core_dump().

As the matter of fact, it's already done - see
        lock_kernel();
        ispipe = format_corename(corename, core_pattern, signr);
        unlock_kernel();
        if (ispipe) {
                /* SIGPIPE can happen, but it's just never processed */
                if(call_usermodehelper_pipe(corename+1, NULL, NULL,
&file)) {
                        printk(KERN_INFO "Core dump to %s pipe
failed\n",
                               corename);
                        goto fail_unlock;
                }
        } else
                file = filp_open(corename,
                                 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE
| flag,
                                 0600);
in do_coredump().  So take a look at fs/exec.c:format_corename() and see
what to feed for it in order to get the equivalent of your patch.
core_patttern is set by sysctl (just say
echo [whatever] >/proc/sys/kernel/core_pattern 
and don't forget quoting, since | should be the first character to
indicate
that you want to pipe coredump through a helper).

I really don't see a reason to do that kind of work in the kernel,
embedded
system or not.
