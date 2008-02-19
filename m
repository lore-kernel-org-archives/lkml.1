Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbYBSPqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbYBSPqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbYBSPqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:46:35 -0500
Received: from linode.ducksong.com ([64.22.125.164]:57700 "EHLO
	linode.ducksong.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbYBSPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:46:35 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 10:46:35 EST
Subject: tee(2) and SPLICE_F_NONBLOCK and can't find eof
From: Patrick McManus <mcmanus@ducksong.com>
To: linux kernel ml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 10:41:32 -0500
Message-Id: <1203435692.5949.84.camel@tng>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I initially sent this query inappropriately to an individual instead of
the list. My apologies.]

re: tee().. I was just playing around with the simple sample on the
manpage (included below) - it uses SPLICE_F_NONBLOCK as a flag. 

on 2.6.22 X86_64 (ubuntu 7.10) when I run the sample. the tee() system
call returns the right number of bytes from the input - sometimes as the
sum of multiple calls. When the input is exhauted tee() starts returning
(-1,EAGAIN) forever.. it never returns 0 and the program never
completes.

without a 0, how is EOF indicated?

do_tee() contains:
       if (!ret && (flags & SPLICE_F_NONBLOCK))
               ret = -EAGAIN;

so it's pretty clear where it comes from.. but finding EOF eludes me ;)
remove the NONBLOCK flag and 0 happens just fine.

NONBLOCK seems gratuitous in the sample, but it would make sense in some
code I am contemplating.. 

Any suggestions?

-Patrick


(This is the sample from the manpage which never completes.. I invoke it
as "cat txt | ./teesample out1 | wc ")

int
main(int argc, char *argv[])
{
    int fd;
    int len, slen;

    assert(argc == 2);

    fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd == -1) {
        perror("open");
        exit(EXIT_FAILURE);
    }

    do {
        /*
         * tee stdin to stdout.
         */
        len = tee(STDIN_FILENO, STDOUT_FILENO,
                  INT_MAX, SPLICE_F_NONBLOCK);

        if (len < 0) {
            if (errno == EAGAIN)
                continue;
            perror("tee");
            exit(EXIT_FAILURE);
        } else
            if (len == 0)
                break;

        /*
         * Consume stdin by splicing it to a file.
         */
        while (len > 0) {
            slen = splice(STDIN_FILENO, NULL, fd, NULL,
                          len, SPLICE_F_MOVE);
            if (slen < 0) {
                perror("splice");
                break;
            }
            len -= slen;
        }
    } while (1);

    close(fd);
    exit(EXIT_SUCCESS);
}


