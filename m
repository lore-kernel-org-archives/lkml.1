Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZAMWnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZAMWnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZAMWnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:43:10 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:18932 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZAMWnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Fk6D1OUrr2P7a7hGQVqZja27x2AenHLKIk6XXV51zxX0HmED7+Iq5Hdmb3ZBZi6+5P
         Jvk9eyXOFNMs9Jsa1eaHlbqUuI6udOCT750VqDVoUvpKnhYLoty5rMW5+nvM26uu/b0G
         nCP0opcemdrjNjQQDNr7Zf5sb1e34JPF8fd2Y=
Message-ID: <cfd18e0f0901131443l3a3203c7le2cbbe9b45c0cc38@mail.gmail.com>
Date: Wed, 14 Jan 2009 11:43:05 +1300
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: waitid() return value strangeness when infop is NULL
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>
In-Reply-To: <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	 <cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test program below.  Two test runs, of which the second shows the
behavior I'm reporting.

$ ./a.out
Created child with PID 7727
infop = 0xbfe608e0
waitid() returned 0
$ ./a.out n
Created child with PID 7729
infop = (nil)
waitid() returned 7729

===

#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <signal.h>
#include <unistd.h>

int
main(int argc, char *argv[])
{
    siginfo_t info, *infop;
    int options, idtype;
    long s;
    pid_t child;

    child = fork();
    if (child == 0)
        exit(0);
    printf("Created child with PID %ld\n", (long) child);

    idtype = P_PID;
    options = WEXITED;
    infop = (argc > 1 && strchr(argv[1], 'n') != NULL) ? NULL : &info;

    printf("infop = %p\n", infop);

    s = syscall(SYS_waitid, idtype, child, infop, options, NULL);
    if (s == -1) {
        perror("waitid");
        exit(EXIT_FAILURE);
    }

    printf("waitid() returned %ld\n", s);

    exit(EXIT_SUCCESS);
}
