Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZBKKz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZBKKz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbZBKKzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:55:14 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:45454 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbZBKKzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:55:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VYfdI4P35jdHESrSQXO+3T8BKuVx98Qd3NOebtrluXhc14R1xGg3cTTpeUy9I2K2XF
         Bo5xggX5EhdQVWikFHZiaA3Kyti72phfQ15OJOwoOeUuC6jmv7kFG4UEUJ0uZEpe9On5
         AYCxvUYG5mXWzH9lYvkOOdFdocATlCP0CkXJs=
MIME-Version: 1.0
Date: Wed, 11 Feb 2009 13:55:08 +0300
Message-ID: <2d42915c0902110255k3c0741a9s6830765bce6be052@mail.gmail.com>
Subject: GFS2 file locking issues
From: Kirill Kuvaldin <kirill.kuvaldin@gmail.com>
To: linux-cluster@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to understand how the FS locking mechanism should work.

I'm running a clustered GFS2 across two nodes, each node is a Xen domU.
To check if locking works correctly I wrote the simple perl script below.
Basically the script opens a file, locks it to prevent others from
writing into it, writes 20 lines into it, then unlocks and closes.

------------------------------------------------------------------------------
#!/usr/bin/perl

# usage:
#  lock.pl filename uniq
#           filename - file name being written to
#           uniq     - an unique label to distinguish output of
different processes

use strict;
use Time::HiRes qw(sleep);
use FileHandle;
use Fcntl ':flock';

my $filename = $ARGV[0];
my $uniq = $ARGV[1];

open FH, '>>', $filename or die $!;
flock(FH,LOCK_EX) or die $!;
FH->autoflush(1);

for (1..20) {
        print FH "$uniq\n";
        sleep (0.1);
}

flock(FH,LOCK_UN);
close FH;
------------------------------------------------------------------------------

I ran that script on both nodes simultaneously with commands:

vm01# perl lock.pl /gfs2/testfile a
vm02# perl lock.pl /gfs2/testfile b

Then to my surprise "a"s and "b"s are randomly shuffled in the testfile like

...
a
a
b
a
b
b
...

whereas I supposed it should have been like

...
a
a
a
b
b
b
...


It looks like either locking is broken in my GFS2 (I use kernel
2.6.18-92.el5xen for CentOS 5.2) or my understanding of locking isn't
correct.
I also tested the script on GFS1 and OCFS2 and it worked well, i.e.
the output was correct.



Thanks,
Kirill
