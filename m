Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbZANBTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbZANBTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 20:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbZANBSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 20:18:50 -0500
Received: from THUNK.ORG ([69.25.196.29]:56200 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbZANBSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 20:18:49 -0500
Date: Tue, 13 Jan 2009 20:18:44 -0500
From: Theodore Tso <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Al Viro <viro@ftp.linux.org.uk>, Alain Knaff <alain@knaff.lu>
Subject: Re: The policy on initramfs decompression failure
Message-ID: <20090114011844.GD14730@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Al Viro <viro@ftp.linux.org.uk>, Alain Knaff <alain@knaff.lu>
References: <496D17F9.8080605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496D17F9.8080605@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 02:38:49PM -0800, H. Peter Anvin wrote:
> As part of the multi-compression-formats patch, the issue has come up as  
> to what is the preferred policy is on initramfs decompression failure,  
> due to either corruption or due to the use of a compression format which  
> the kernel does not support.
>
> I had personally assumed the proper policy would be to panic, since it  
> is unlikely to mean the system can be booted.  However, Ingo brought up  
> the case where the initramfs is auxilliary to being able to boot the  
> full system, for example the initramfs supplied is primarily a data  
> carrier, and either the builtin initramfs or the kernel itself is  
> sufficient to boot.

I would suggest a default policy of "panic", and a way of overriding
the policy, probably with a boot command-line option.  The reality is
that most of the time, the failure case of a failed or partially
failed initramfs is not going to be well tested, as you have pointed
out, the downsidesof a booted-but-dysfunctional system is often going
to be worse than a hard failure.  The partially decoded case is going
to be even worse, so I can see a three-way policy:

   failed-initramfs-decode=panic      Panic on failed initramfs
   failed-initramfs-decode=partial    If the initramfs fails part-way in, 
   				      decode what you can and let the boot
				      system see what files could be fully
				      decypted
   failed-initramfs-decode=allow      If the initramfs decryption fails
   				      part-of-the-way in, continue the
				      boot, but do not provide the partial
				      initramfs --- i.e., this is the 
				      all-or-nothing option

If this is too complicated, I'd be happy with the "panic on failed
initramfs".  After all, the user can always simply delete the initrd
specifier from their grub boot configuration, and simply retry the
boot....

						- Ted
