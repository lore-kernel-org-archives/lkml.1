Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXCBKeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXCBKeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 05:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933318AbXCBKeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 05:34:20 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:13634 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317AbXCBKeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 05:34:19 -0500
X-IronPort-AV: i="4.14,241,1170651600"; 
   d="scan'208"; a="29615805:sNHT21468041"
Subject: Questions about the SYSVIPC share memory on NOMMU uClinux
	architecture
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 02 Mar 2007 18:33:49 +0800
Message-Id: <1172831630.5264.139.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Recently, I was struggling in a bug about the shm->nattch. Actually, the
test case is from LTP kernel/syscall/ipc/shmctl/shmctl01.c code. We
ported it to the uClinux-blackfin platform.

The algorithm is very simple. 
a) the parent process will create a share memory 
b) parent will vfork/execlp 4 children process
c) children will call shmat() attach to the share memory (shm->nattch
should be increased), then children will pause()
d) parent call shmclt() to get the share memory nattch, if nattch != 4,
then the testcase will fail.

In our uClinux-blackfin platform, nattch = 1.

So I dig into the source code ipc/shm.c, then there are some questions
about the code.

a)
in function do_shmat(), after nattch++ why nattch-- as following:
================================================================================
 user_addr = (void*) do_mmap (file, addr, size, prot, flags, 0);

	// here no return or goto valid place.

invalid:
        up_write(&current->mm->mmap_sem);

        mutex_lock(&shm_ids(ns).mutex);
        shp = shm_lock(ns, shmid);
        BUG_ON(!shp);
        shp->shm_nattch--; /* Why??? */
        if(shp->shm_nattch == 0 &&
           shp->shm_perm.mode & SHM_DEST)
                shm_destroy(ns, shp);
        else
                shm_unlock(shp);
        mutex_unlock(&shm_ids(ns).mutex);

        *raddr = (unsigned long) user_addr;
        err = 0;
        if (IS_ERR(user_addr))
                err = PTR_ERR(user_addr);
out:
        return err;
================================================================================

b) do_mmap() -> mm/nommu.c do_mmap_pgoff()
When create a new vma structure, shm_open(), shm_inc() will be called. Then nattch++.
So the nattch counting is disordered.

Please give me some hint about it. Actually, this case can pass on X86 platform

Thanks
-Bryan Wu
