Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbYIAOH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbYIAOH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 10:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYIAOHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 10:07:48 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:46668 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbYIAOHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 10:07:47 -0400
Message-ID: <59911.166.70.238.45.1220276384.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <48BAA364.7080503@panasas.com>
References: <200808290547.m7T5leOa016106@wolfmountaingroup.com>
    <48BAA364.7080503@panasas.com>
Date: Mon, 1 Sep 2008 07:39:44 -0600 (MDT)
Subject: Re: [PATCH 2.6.27-rc5 1/29] mdb: export ioapic read routines and 
     detected ioapic count
From: jmerkey@wolfmountaingroup.com
To: "Benny Halevy" <bhalevy@panasas.com>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jeff, general comment: can you please send your patches as replies
> to a leading message so they all be linked as a single thread?
> Threading them together is helpful for maintaining several
> versions of your patchset and it's simpler to ignore if one's
> not really interested in this topic at all.
>
> Benny
>

Hi Benny,

I was already scolded about this by a few folks.  I had not located the
git email programs when I submitted this project and I wrote something
myself to submit them.  (see attached).  I have thrown the program in the
trash I wrote to do this and moved to git.

Now I have reviewed the git clients and patch tools and I understand and
will use git and I see now why git works this way with the reply chain. I
will not be submitting patch series on this list for every release unless
the code has had major additions or changes in the future.   I will
instead post the patches to the project site with a single post on this
list to point to the patches.

I will post patch series when x86_64 is finished and I have completed my
rewrite of traps_32.c and traps_64.c -- Linux needs nested TSS gates over
all the exceptions so the system can handle nested exceptions and switch
to a known good stack during faults.  At present, what's there is ok but
not as resilient as it could be.

Jeff



#include <unistd.h>
#include <stdio.h>
#include <string.h>

#define TESTING 1

unsigned char buffer[8192];
unsigned char filename[64];

int output_comments(FILE *fl, int j)
{
    fprintf(fl, "\n");
    return 0;
}

int main(int argc, char *argv[])
{
    register int i = 1, j;
    register FILE *fp = NULL, *fl, *fs;
    char *s, *p;

    while (s = fgets(buffer, 8192, stdin))
    {
       if (!strncmp(s, "diff", 4))
         continue;

       if (!strncmp(s, "---", 3))
       {
          if (fp)
          {
             i++;
             fclose(fp);
          }

          sprintf(filename, "%i.patch", i);
          fp = fopen(filename, "wb");
          if (!fp)
          {
             printf("file open error [%s]\n", filename);
             return 1;
          }

          p = strchr(s, '/');
          if (p)
          {
             fprintf(fp, "--- a");
             fprintf(fp, "%s", p);
          }
          else
             fprintf(fp, "%s", s);
          continue;
       }

       if (!strncmp(s, "+++", 3))
       {
          p = strchr(s, '/');
          if (p)
          {
             fprintf(fp, "+++ b");
             fprintf(fp, "%s", p);
          }
          else
             fprintf(fp, "%s", s);
          continue;
       }

       if (fp);
          fprintf(fp, "%s", s);
    }
    if (fp)
       fclose(fp);

    fs = fopen("mailer", "wb");
    if (!fs)
    {
       printf("file open error [mailer]\n");
       return 1;
    }

    for (j=1; j <= i; j++)
    {
       sprintf(filename, "%i.patch", j);
       fp = fopen(filename, "rb");
       if (!fp)
       {
          printf("file open error [%s]\n", filename);
          return 1;
       }

       sprintf(filename, "%i.final", j);
       fl = fopen(filename, "wb");
       if (!fl)
       {
          printf("file open error [%s]\n", filename);
          return 1;
       }
       fprintf(fs, "sendmail -f jmerkey@wolfmountaingroup.com -t < %s\n",
               filename);

#if TESTING
       fprintf(fl, "To:jeff@wolfmountaingroup.com\n");
#else
       fprintf(fl, "To:linux-kernel@vger.kernel.org\n");
#endif
       fprintf(fl, "From:jmerkey@wolfmountaingroup.com\n");
       fprintf(fl, "Subject:[PATCH %s %i/%i] mdb: ",
               argv[1] ? argv[1] : "", j, i);

       output_comments(fl, j);

       fprintf(fl, "Signed-off-by: Jeffrey Vernon Merkey "
                   "(jmerkey@wolfmountaingroup.com)\n\n");

       while (s = fgets(buffer, 8192, fp))
          fprintf(fl, "%s", s);

       fclose(fp);
       sprintf(filename, "%i.patch", j);
       unlink(filename);

       fclose(fl);
    }
    fclose(fs);
    chmod("mailer", 755);
    return 0;
}













