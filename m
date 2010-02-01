Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab0BAVEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 16:04:40 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:63530 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab0BAVEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 16:04:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=s6CM5sHhn++tcl0X4sSzt7I6uhX5KiSe/A51Z70Ho5Hepd4leAlkd7HrdyNWdU5Yle
         v0+Ntotn+fJVUg78TRN9xrODbMXbvA7brCchMaPmlqOm0PbQ34vdkrinZZIgZcEdbET2
         qxOqtKl3X/P49c7ESVA3xIt+A7eyDlycecY9M=
MIME-Version: 1.0
In-Reply-To: <20100201204632.GK1414@holoscopio.com>
References: <1264800197-29523-1-git-send-email-cascardo@holoscopio.com>
	 <201001302257.09354.arnd@arndb.de>
	 <520f0cf11001301507k20e3cf8dqa73026e12f3a1767@mail.gmail.com>
	 <201001310520.55813.arnd@arndb.de>
	 <20100131052942.GA12320@core.coreip.homeip.net>
	 <520f0cf11002011222h134dbf06rf1db612da9a9728@mail.gmail.com>
	 <520f0cf11002011227s74e57673j3922941f7ee87989@mail.gmail.com>
	 <20100201204632.GK1414@holoscopio.com>
Date: Mon, 1 Feb 2010 22:04:37 +0100
X-Google-Sender-Auth: c0e519be86a0e8e4
Message-ID: <520f0cf11002011304w64fac454s8192f271bc27fad6@mail.gmail.com>
Subject: Re: [PATCH] input: remove BKL from uinput open function
From: John Kacur <jkacur@redhat.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 1, 2010 at 9:46 PM, Thadeu Lima de Souza Cascardo
<cascardo@holoscopio.com> wrote:
> On Mon, Feb 01, 2010 at 09:27:22PM +0100, John Kacur wrote:
>> On Mon, Feb 1, 2010 at 9:22 PM, John Kacur <jkacur@redhat.com> wrote:
>> > On Sun, Jan 31, 2010 at 6:29 AM, Dmitry Torokhov
>> > <dmitry.torokhov@gmail.com> wrote:
>> >> On Sun, Jan 31, 2010 at 05:20:55AM +0100, Arnd Bergmann wrote:
>> >>> On Sunday 31 January 2010, John Kacur wrote:
>> >>> > > Sorry, I should have been clearer, but not implementing llseek
>> >>> > > is the problem I was referring to: When a driver has no explicit
>> >>> > > .llseek operation in its file operations and does not call
>> >>> > > nonseekable_open from its open operation, the VFS layer will
>> >>> > > implicitly use default_llseek, which takes the BKL. We're
>> >>> > > in the process of changing drivers not to do this, one by one
>> >>> > > so we can kill the BKL in the end.
>> >>> > >
>> >>> >
>> >>> > I know we've discussed this before, but why wouldn't the following
>> >>> > make more sense?
>> >>> >  .llseek         = no_llseek,
>> >>>
>> >>> That's one of the possible solutions. Assigning it to generic_file_llseek
>> >>> also gets rid of the BKL but keeps the current behaviour (calling seek
>> >>> returns success without having an effect, no_llseek returns -ESPIPE),
>> >>> while calling nonseekable_open has the other side-effect of making
>> >>> pread/pwrite fail with -ESPIPE, which is more consistent than
>> >>> only failing seek.
>> >>>
>> >>
>> >> OK, so how about the patch below (on top of Thadeu's patch)?
>> >>
>> >> --
>> >> Dmitry
>> >>
>> >> Input: uinput - use nonseekable_open
>> >>
>> >> Seeking does not make sense for uinput so let's use nonseekable_open
>> >> to mark the device non-seekable.
>> >>
>> >> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
>> >> ---
>> >>
>> >>  drivers/input/misc/uinput.c |    7 +++++++
>> >>  1 files changed, 7 insertions(+), 0 deletions(-)
>> >>
>> >>
>> >> diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
>> >> index 18206e1..7089151 100644
>> >> --- a/drivers/input/misc/uinput.c
>> >> +++ b/drivers/input/misc/uinput.c
>> >> @@ -278,6 +278,7 @@ static int uinput_create_device(struct uinput_device *udev)
>> >>  static int uinput_open(struct inode *inode, struct file *file)
>> >>  {
>> >>        struct uinput_device *newdev;
>> >> +       int error;
>> >>
>> >>        newdev = kzalloc(sizeof(struct uinput_device), GFP_KERNEL);
>> >>        if (!newdev)
>> >> @@ -291,6 +292,12 @@ static int uinput_open(struct inode *inode, struct file *file)
>> >>
>> >>        file->private_data = newdev;
>> >>
>> >> +       error = nonseekable_open(inode, file);
>> >> +       if (error) {
>> >> +               kfree(newdev);
>> >> +               return error;
>> >> +       }
>> >> +
>> >>        return 0;
>> >>  }
>> >>
>> >>
>> >
>> > Hmnn, if you look at nonseekable_open() it will always return 0. I
>> > think you can just do the following.
>> >
>> > diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
>> > index 18206e1..697c0a6 100644
>> > --- a/drivers/input/misc/uinput.c
>> > +++ b/drivers/input/misc/uinput.c
>> > @@ -291,7 +291,7 @@ static int uinput_open(struct inode *inode, struct file *fil
>> >
>> >        file->private_data = newdev;
>> >
>> > -       return 0;
>> > +       return nonseekable_open(inode, file);
>> >  }
>> >
>> > Signed-off-by: John Kacur <jkacur@redhat.com>
>> >
>>
>> Btw, Thadeu Lima de Souza Cascardo should just combine that all into
>> one patch, no point really in making two patches out of that.
>
> That's fine to me. But since Dmitry has already applied it, I see no
> problem at all that this is two commits. Or would there be any problem
> removing the lock in open and not doing nonseekable_open?
>
> As far as I get, nonseekable_open only resets the flags that will make
> it do the right thing for lseek, pread and pwrite. This will get rid of
> the BKL for these calls, but this is independent of getting rid of it
> for the open call.
>
> I don't disagree that doing both at the same time is OK. But I don't
> agree that doing them separately is not OK. This way, you may get the
> credits for what you (and not I) have done.  :-)
>
> But either way is fine for me.
>
> Regards,
> Cascardo.
>

Ok, I didn't know that he already applied it. No need to make a big
deal about it, two commits are fine.
If he hadn't already applied it then it could logically go together as
one commit.

John
