Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbXLJDN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbXLJDN3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 22:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXLJDNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 22:13:18 -0500
Received: from mailgw.cvut.cz ([147.32.3.235]:59840 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbXLJDNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 22:13:17 -0500
X-Greylist: delayed 1249 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 22:13:16 EST
Message-ID: <475CA9EA.1090405@vc.cvut.cz>
Date: Sun, 09 Dec 2007 18:52:26 -0800
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071119 Iceape/1.1.7 (Debian-1.1.7-1)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, rjw@sisk.pl,
       trond.myklebust@fys.uio.no, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org, den@openvz.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 2.6.24-rc4] proc: Remove/Fix proc generic d_revalidate
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>	<1197067918.10831.13.camel@heimdal.trondhjem.org>	<20071207151444.af5d8e11.akpm@linux-foundation.org>	<200712080043.29292.rjw@sisk.pl>	<20071208000043.GC1951@martell.zuzino.mipt.ru>	<20071207161508.afe8fdf1.akpm@linux-foundation.org> <m1lk85q0cw.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1lk85q0cw.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Ultimately to implement /proc perfectly we need an implementation
> of d_revalidate because files and directories can be removed behind
> the back of the VFS, and d_revalidate is the only way we can let
> the VFS know that this has happened.
> 
> So until we get a proper test for keeping dentries in the dcache
> fix the current d_revalidate method by completely removing it.  This
> returns us to the current status quo.

Hello,
    I know that I'm late to the party, but mount points is not only 
problem with d_revalidate.  With your patch in place module below gets 
refcount incremented by two every time I do 'ls -la /proc/fs/vmblock'.


#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/proc_fs.h>

static int vmblockinit(void) {
    struct proc_dir_entry *controlProcDirEntry;

    /* Create /proc/fs/vmblock */
    controlProcDirEntry = proc_mkdir("vmblock", proc_root_fs);
    if (!controlProcDirEntry) {
       printk(KERN_DEBUG "Bad...\n");
       return -EINVAL;
    }
    controlProcDirEntry->owner = THIS_MODULE;
    return 0;
}

static void vmblockexit(void) {
    remove_proc_entry("vmblock", proc_root_fs);
}

module_init(vmblockinit);
module_exit(vmblockexit);


(code comes from VMware's vmblock module, 
http://sourceforge.net/project/showfiles.php?group_id=204462)
						Thanks,
							Petr

