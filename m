Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbZFJQEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbZFJQEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 12:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbZFJQEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 12:04:24 -0400
Received: from nox.protox.org ([88.191.38.29]:42925 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbZFJQEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:04:23 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jun 2009 12:04:23 EDT
Subject: Radeon kernel modesetting patch (as staging) please review
From: Jerome Glisse <glisse@freedesktop.org>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.sf.net
Content-Type: text/plain
Date: Wed, 10 Jun 2009 17:55:18 +0200
Message-Id: <1244649318.9942.33.camel@earl.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

For size reason (~1.2M) the patch can be found here (along with others
needed patches):
http://people.freedesktop.org/~glisse/kms/0006-radeon-introduce-kernel-modesetting-for-radeon-hard.patch

This work depends on Thomas TTM memory manager posted earlier and was
written by Dave Airlie, Alex Deucher and myself. We would like to get
radeon kernel modesetting in 2.6.31 as a staging driver but given the
layout of drm/radeon we have the code source is in
drivers/gpu/drm/radeon and not in subfolder of drivers/staging. Is this
an issue ?

The main reason, i think of, for considering radeon/KMS as staging
driver is security. With current patch you can (with some difficulties)
theoretically write or read GPU object of other process, i am pretty
confident that you cannot access system ram beside one allocated for
GPU object. Also we might need to change a little bit the ABI (there is
no yet userspace release of code supporting this ABI it's all in various
branch ddx/mesa/libdrm).

Meanwhile we would still like to give the opportunity to people to test
this code and thus helps us find bugs or design errors. I would like to
thank all people who have done early testing on this code.


Here is a brief description of code layout for people courageous enough
to review the patch:
atom* files hold atom helper & interpreter, atombios is a kind of script
language used by AMD to provide a set of functions that driver can use,
this is mostly useful for low level GPU initialization (setting up
video ram frequency, gpu frequency, video ram refresh timing, ... which
are board specific and can vary from one vendor to the other for the
same asic). atombios also provide an API to perform mode setting and
thus helps in abstracting changes in mode setting part of the GPU.

radeon_kms.c have code for wrapping around old ioctl and return invalid
anytime userspace try to call them if mode setting is enabled.

radeon_device.c is where the initialization and resume/suspend path
starts.

radeon_object.c/radeon_ttm.c are a thin layer for abstracting the
underlying memory manager used. Motivation is to allow to easily
modify/improve the underlying memory manager while not having to
update various files in the gpu driver. It also provide helper
functions to simplify common task often done by different component
of the code.

radeon_display.c is the core of mode setting functionality

radeon_legacy* holds code for doing mode setting on non atombios
hw (r1xx/r2xx/r3xx/r4xx).

radeon_gem.c holds the userspace api of the memory manager

radeon_cs.c holds the new userspace api for submitting command
to the GPU. This API is designed with memory management in mind
and is closer to what GPU can understand.

radeon_asic.h holds the various asic specific functions callback
structure, if you want to know which functions is called on a given
asic for a given task it's where you should look.

r100.c/r300.c/rs400.c/rv515.c/r520.c/rs600.c/rs690.c/... are files
holding asic specific functions, note that new asic often reuse some
part of older asic, for instance the r100 cp is the same up to r5xx
hw so you will see that r100_cp_* functions are used by large range
of hw. Idea here is to avoid duplication while allowing to clearly
spot differences btw asics.

Jerome Glisse


Below is commit message :

    radeon: introduce kernel modesetting for radeon hardware
    
    Add kernel modesetting support to radeon driver, use the ttm memory
    manager to manage memory and DRM/GEM to provide userspace API.
    In order to avoid backward compatibility issue and to allow clean
    design and code the radeon kernel modesetting use different code
path
    than old radeon/drm driver.
    
    When kernel modesetting is enabled the IOCTL of radeon/drm
    driver are considered as invalid and an error message is printed
    in the log and they return failure.
    
    KMS enabled userspace will use new API to talk with the radeon/drm
    driver. The new API provide functions to create/destroy/share/mmap
    buffer object which are then managed by the kernel memory manager
    (here TTM). In order to submit command to the GPU the userspace
    provide a buffer holding the command stream, along this buffer
    userspace have to provide a list of buffer object used by the
    command stream. The kernel radeon driver will then place buffer
    in GPU accessible memory and will update command stream to reflect
    the position of the different buffers.
    
    The kernel will also perform security check on command stream
    provided by the user, we want to catch and forbid any illegal use
    of the GPU such as DMA into random system memory or into memory
    not owned by the process supplying the command stream. This part
    of the code is still incomplete and this why we propose that patch
    as a staging driver addition, future security might forbid current
    experimental userspace to run.
    
    This code support the following hardware : R1XX,R2XX,R3XX,R4XX,R5XX
    (radeon up to X1950). Works is underway to provide support for R6XX,
    R7XX and newer hardware (radeon from HD2XXX to HD4XXX).
    
    Authors:
        Jerome Glisse <jglisse@redhat.com>
        Dave Airlie <airlied@redhat.com>
        Alex Deucher <alexdeucher@gmail.com>
    
    Signed-off-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
    Signed-off-by: Alex Deucher <alexdeucher@gmail.com>


