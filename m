Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935864Ab0COIzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 04:55:08 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55902 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935629Ab0COIzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 04:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=K4AKj0QnA3hGt1eeDo/jDwcHIaOcwFhiWOmDglO+jppStXYbkceARB3IZOFNsbMQcM
         bfZ39xoTSGZXoSC7mLA/0wdKgUGnYbTzRSpiV6Df8Z/Envrxr0NGHwnpyel8uXSDrbGo
         odS4tl7FRq5fALDlMp/+hozY5QhB6qaGeEyyk=
MIME-Version: 1.0
In-Reply-To: <4B83106C.7040203@cs.columbia.edu>
References: <4B83106C.7040203@cs.columbia.edu>
Date: Mon, 15 Mar 2010 17:55:01 +0900
X-Google-Sender-Auth: ed6a03f175271830
Message-ID: <a1c54a921003150155q4a0c7fc1vb02ba0464b07f452@mail.gmail.com>
Subject: Re: Linux Checkpoint-Restart - v19
From: Jiro SEKIBA <jir@dependable-os.net>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, jir@dependable-os.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to evaluate external checkpoint/restart with cr-v19 kernel.
However, when I restart, I got "Killed" message in stdout.
Do you have any tips or clue that are not in
Documentation/checkpoint/usage.txt ?

I'm using kernel pulled from
git://git.ncl.cs.columbia.edu/pub/git/linux-cr.git .
checkout tag named "ckpt-v19". Base distro is ubuntu 9.10.

I ran self checkpioint/restart sample program in Documentation/checkpint.
It works as written in usage.txt.
However, I can not make external checkpint/restart work properly.

I made a simple test program bellow and create checkpoint externally using
the program in Documentation/checkpoint/, it looks checkpoint file is
created properly.
However, when I ran self_restart < ckpt.image, I got "Killed" message.

Is there any extra configurations other than cgroup freezer and
checkpint/restart ?
Or any limitation other than closing stdout,err,in ?

what I did is following:

# mount -t cgroup -o freezer cgroup /cgroup
# mkdir /cgroup/0
..
# ./test &
# PID=$(ps | grep test | cut -f 2 -d' ')
# echo $PID > /cgroup/0/tasks
# sleep 3
# echo FROZEN > /cgroup/0/freezer.state
# ./checkpoint $PID > ckpt.image
# mv /tmp/test.out /tmp/test.out.orig
# cp /tmp/test.out.orig /tmp/test.out
# echo THAWED > /cgroup/0/freezer.state
# ./self_restart < ckpt.image
Killed

----- test.c -----
int main(void)
{
  FILE *fp;
  int i;

  close(0);
//  close(1);  // I got SEGV when I uncomment this line, when restarting
  close(2);

  fp = fopen("/tmp/test.out","w+");

  for(i=0;i<10;i++) {
    fprintf(fp,"%d\n",i);
    fflush(fp);
    sleep(1);
  }

  fclose(fp);
  return 0;
}
----- test.c -----

Thank you very much in advance

2010/2/23 Oren Laadan <orenl@cs.columbia.edu>:
> Hi Andrew,
>
> We've put a stake in the ground for our next set of checkpoint/restart
> patches, v19. It has some great new stuff, and we put extra effort to
> address your concerns. We would like to have the code included in -mm
> for wider feedback and testing.
>
> This one is able to checkpoint/restart screen and vnc sessions, and
> live-migrate network servers between hosts. It also adds support for
> x86-64 (in addition to x86-32, s390x and powerpc). It is rebased to
> kernel 2.6.33-rc8.
>
> Since one of your main concerns was about what is not yet implemented
> and how complicated or ugly it will be to support that, we've put up
> a wiki page to address that. In it there is a simple table that lists
> what is not implemented and the anticipated solution impact, and for
> some entries a link to more details.
>
> The page is here:   http://ckpt.wiki.kernel.org/index.php/Checklist
>
> We want to stress that the patchset is already very useful as-is. We
> will keep working to implement more features cleanly. Some features we
> are working on include network namespaces and device configurations,
> mounts and mounts namespaces, and file locks. Should a complicated
> feature prove hard to implement, users have alternatives systems like
> kvm, until we manage to come up with a clean solution.
>
> We believe that maintenance is best addressed through testing. We now
> have a comprehensive test-suite to automatically find regressions.
> In addition, we ran LTP and the results are the same with CHECKPOINT=n
> and =y.
>
> If desired we'll send the whole patchset to lkml, but the git trees
> can be seen at:
>
>  kernel:       http://www.linux-cr.org/git/?p=linux-cr.git;a=summary
>  user tools:   http://www.linux-cr.org/git/?p=user-cr.git;a=summary
>  tests suite:  http://www.linux-cr.org/git/?p=tests-cr.git;a=summary
>
> Thanks,
>
> Application checkpoint/restart team
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
